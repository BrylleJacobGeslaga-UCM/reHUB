import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../models/post.dart';
import '../../models/report.dart';
import '../../services/block_service.dart';
import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/post_card.dart';
import '../../widgets/report_sheet.dart';
import '../feed/comments_screen.dart';
import '../feed/compose_screen.dart';

/// "Recent posts" on a hub page. Members (and admins) only, like the feed.
class HubPostsSection extends StatefulWidget {
  const HubPostsSection({
    super.key,
    required this.user,
    required this.hub,
    required this.profile,
    required this.joined,
  });

  final User user;
  final Hub hub;
  final Map<String, dynamic> profile;
  final bool joined;

  @override
  State<HubPostsSection> createState() => _HubPostsSectionState();
}

class _HubPostsSectionState extends State<HubPostsSection> {
  int _limit = 5;
  late Stream<List<Post>> _posts = _query();
  Map<String, String> _blocked = const {};
  StreamSubscription<Map<String, String>>? _blockSub;

  Stream<List<Post>> _query() =>
      PostService.instance.hubPosts(widget.hub.id, limit: _limit + 1);

  @override
  void initState() {
    super.initState();
    if (!widget.user.isAnonymous) {
      _blockSub = BlockService.instance.blocked(widget.user.uid).listen((b) {
        if (mounted) setState(() => _blocked = b);
      });
    }
  }

  @override
  void didUpdateWidget(HubPostsSection old) {
    super.didUpdateWidget(old);
    // Joining/leaving changes what the rules let us read; re-run the query.
    if (old.joined != widget.joined) _posts = _query();
  }

  @override
  void dispose() {
    _blockSub?.cancel();
    super.dispose();
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _compose() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComposeScreen(
        user: widget.user,
        profile: widget.profile,
        initialHubId: widget.hub.id,
      ),
    ));
  }

  Future<void> _react(Post post, Reaction r, Reaction? current) async {
    try {
      await PostService.instance
          .react(
              uid: widget.user.uid,
              postId: post.id,
              reaction: r,
              current: current);
    } catch (_) {
      _show('Couldn’t save your reaction. Try again.');
    }
  }

  Future<void> _delete(Post post) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this post?'),
        content: const Text('This can’t be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await PostService.instance.delete(uid: widget.user.uid, postId: post.id);
      _show('Post deleted.');
    } catch (_) {
      _show('Couldn’t delete the post. Try again.');
    }
  }

  void _report(Post post) => showReportSheet(
        context,
        user: widget.user,
        target: ReportTarget(
          type: ReportType.post,
          path: 'posts/${post.id}',
          hubId: post.hubId,
          hubName: post.hubName,
          postId: post.id,
          preview: post.body,
          authorName: post.displayName,
        ),
      );

  Widget _note(IconData icon, String text) => AppCard(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSubtle),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: AppText.caption.copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final canPost = widget.joined && !widget.user.isAnonymous;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.article_outlined,
                size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(child: Text('Recent posts', style: AppText.title)),
            if (canPost)
              TextButton.icon(
                onPressed: _compose,
                icon: const Icon(Icons.add_rounded,
                    size: 18, color: AppColors.primary),
                label: Text('Share',
                    style: AppText.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700)),
              ),
          ],
        ),
        const SizedBox(height: 10),
        StreamBuilder<List<Post>>(
          stream: _posts,
          builder: (context, snap) {
            // Non-members (and guests) can't read hub posts.
            if (snap.hasError || (!widget.joined && !snap.hasData)) {
              return _note(Icons.lock_outline_rounded,
                  'Posts are shared with members only. Join to see them.');
            }
            if (!snap.hasData) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary)),
              );
            }
            final all = snap.data!
                .where((p) =>
                    p.authorId == null || !_blocked.containsKey(p.authorId))
                .toList();
            if (all.isEmpty) {
              return _note(
                Icons.forum_outlined,
                canPost
                    ? 'No posts yet. Tap “Share” to start the conversation.'
                    : 'No posts in this hub yet.',
              );
            }
            final hasMore = snap.data!.length > _limit;
            final posts = all.take(_limit).toList();

            return StreamBuilder<Map<String, Reaction>>(
              stream: widget.user.isAnonymous
                  ? null
                  : PostService.instance.myReactions(widget.user.uid),
              builder: (context, reactSnap) => StreamBuilder<Set<String>>(
                stream: widget.user.isAnonymous
                    ? null
                    : PostService.instance.myPostIds(widget.user.uid),
                builder: (context, mineSnap) {
                  final reactions = reactSnap.data ?? const {};
                  final mine = mineSnap.data ?? const <String>{};
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final p in posts)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: PostCard(
                            post: p,
                            myReaction: reactions[p.id],
                            isMine: mine.contains(p.id),
                            onReact: (r) => _react(p, r, reactions[p.id]),
                            onComment: () => openComments(context,
                                user: widget.user,
                                profile: widget.profile,
                                postId: p.id),
                            onDelete: () => _delete(p),
                            onReport: () => _report(p),
                            onBlock: p.authorId == null ||
                                    p.authorId == widget.user.uid
                                ? null
                                : () => confirmBlock(context,
                                    uid: widget.user.uid,
                                    targetId: p.authorId!,
                                    name: p.displayName),
                          ),
                        ),
                      if (hasMore)
                        Center(
                          child: TextButton(
                            onPressed: () => setState(() {
                              _limit += 10;
                              _posts = _query();
                            }),
                            child: Text('Show more posts',
                                style: AppText.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
