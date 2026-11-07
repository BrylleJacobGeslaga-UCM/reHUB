import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../models/report.dart';
import '../../widgets/post_card.dart';
import '../../widgets/report_sheet.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import '../auth/sign_up_screen.dart';
import '../hubs/discover_screen.dart';
import 'comments_screen.dart';
import 'compose_screen.dart';

/// Posts from the hubs you've joined. Posts are private to each hub, so
/// guests and non-members never see them.
class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Stream<List<Post>>? _feed;
  List<String> _feedFor = const [];

  bool get _isGuest => widget.user.isAnonymous;
  List<String> get _joined =>
      List<String>.from(widget.profile['joinedHubs'] ?? const [])..sort();

  /// Only rebuild the feed query when the joined hubs actually change.
  Stream<List<Post>> _feedStream() {
    final joined = _joined;
    if (_feed == null || !listEquals(joined, _feedFor)) {
      _feedFor = joined;
      _feed = PostService.instance.feed(joined);
    }
    return _feed!;
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _compose() {
    if (_isGuest) {
      showGuestPrompt(context, action: 'share updates');
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComposeScreen(user: widget.user, profile: widget.profile),
    ));
  }

  void _discover() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DiscoverScreen(user: widget.user, joined: _joined),
    ));
  }

  void _comments(Post post) => openComments(context,
      user: widget.user, profile: widget.profile, postId: post.id);

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

  Future<void> _react(Post post, Reaction r) async {
    try {
      await PostService.instance
          .react(uid: widget.user.uid, postId: post.id, reaction: r);
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

  Widget _body() {
    if (_isGuest) {
      return EmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'Posts are shared within hubs',
        message: 'To keep things safe, updates are only visible to members '
            'of each hub. Create an account and join a hub to see them.',
        action: AppButton(
          label: 'Create an account',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          ),
        ),
      );
    }
    if (_joined.isEmpty) {
      return EmptyState(
        icon: Icons.groups_outlined,
        title: 'Join a hub to get started',
        message: 'Your feed shows updates from the hubs you’re part of. '
            'Posts stay private to each hub.',
        action: AppButton(label: 'Explore hubs', onPressed: _discover),
      );
    }

    return StreamBuilder<List<Post>>(
      stream: _feedStream(),
      builder: (context, postsSnap) {
        if (postsSnap.hasError) {
          return Column(
            children: [
              const EmptyState(
                icon: Icons.build_outlined,
                title: 'The feed needs a quick setup',
                message: 'Firestore needs an index for this query. '
                    'Details below.',
              ),
              SelectableText(
                postsSnap.error.toString(),
                style: AppText.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          );
        }
        if (!postsSnap.hasData) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        final posts = postsSnap.data!;
        if (posts.isEmpty) {
          return EmptyState(
            icon: Icons.article_outlined,
            title: 'No updates yet',
            message: 'Be the first to share how your week is going.',
            action: AppButton(label: 'Share an update', onPressed: _compose),
          );
        }

        return StreamBuilder<Map<String, Reaction>>(
          stream: PostService.instance.myReactions(widget.user.uid),
          builder: (context, reactSnap) {
            return StreamBuilder<Set<String>>(
              stream: PostService.instance.myPostIds(widget.user.uid),
              builder: (context, mineSnap) {
                final reactions = reactSnap.data ?? const {};
                final mine = mineSnap.data ?? const <String>{};
                return Column(
                  children: [
                    for (final p in posts)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: PostCard(
                          post: p,
                          myReaction: reactions[p.id],
                          isMine: mine.contains(p.id),
                          onReact: (r) => _react(p, r),
                          onComment: () => _comments(p),
                          onDelete: () => _delete(p),
                          onReport: () => _report(p),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(
            title: 'Your feed',
            subtitle: 'Updates from your hubs',
            trailing: Tooltip(
              message: 'New update',
              child: Material(
                color: AppColors.surface,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _compose,
                  child: const SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(Icons.add_rounded,
                        size: 28, color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: _body(),
          ),
        ],
      ),
    );
  }
}
