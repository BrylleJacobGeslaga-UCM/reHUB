import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../services/block_service.dart';
import '../../services/post_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../models/report.dart';
import '../../widgets/post_card.dart';
import '../../widgets/report_sheet.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import '../hubs/hub_detail_screen.dart';

void openComments(
  BuildContext context, {
  required User user,
  required Map<String, dynamic> profile,
  required String postId,
}) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) =>
        CommentsScreen(user: user, profile: profile, postId: postId),
  ));
}

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({
    super.key,
    required this.user,
    required this.profile,
    required this.postId,
  });

  final User user;
  final Map<String, dynamic> profile;
  final String postId;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _input = TextEditingController();
  bool _anonymous = false;
  bool _sending = false;

  bool get _isGuest => widget.user.isAnonymous;

  @override
  void initState() {
    super.initState();
    _input.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await PostService.instance.addComment(
        uid: widget.user.uid,
        postId: widget.postId,
        body: text,
        anonymous: _anonymous,
        authorName: (widget.profile['name'] as String?) ??
            widget.user.displayName ??
            'Member',
      );
      _input.clear();
      if (mounted) FocusScope.of(context).unfocus();
    } catch (_) {
      _show('Couldn’t send your comment. Try again.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _delete(Comment c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this comment?'),
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
      await PostService.instance.deleteComment(
          uid: widget.user.uid, postId: widget.postId, commentId: c.id);
    } catch (_) {
      _show('Couldn’t delete the comment. Try again.');
    }
  }

  void _report(ReportTarget target) =>
      showReportSheet(context, user: widget.user, target: target);

  Future<void> _react(Reaction r, Reaction? current) async {
    if (_isGuest) {
      await showGuestPrompt(context, action: 'react to posts');
      return;
    }
    try {
      await PostService.instance
          .react(
          uid: widget.user.uid,
          postId: widget.postId,
          reaction: r,
          current: current);
    } catch (_) {
      _show('Couldn’t save your reaction. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Post?>(
        stream: PostService.instance.post(widget.postId),
        builder: (context, postSnap) {
          if (postSnap.hasError ||
              (postSnap.connectionState == ConnectionState.active &&
                  postSnap.data == null)) {
            return Column(
              children: [
                ScreenHeader(
                    title: 'Comments',
                    onBack: () => Navigator.of(context).pop()),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    postSnap.hasError
                        ? 'This post is only visible to members of its hub.'
                        : 'This post was deleted.',
                    textAlign: TextAlign.center,
                    style: AppText.body,
                  ),
                ),
              ],
            );
          }
          final post = postSnap.data;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ScreenHeader(
                        title: 'Comments',
                        subtitle: post?.hubName,
                        onBack: () => Navigator.of(context).pop(),
                      ),
                      if (post != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          child: _Thread(
                            user: widget.user,
                            post: post,
                            onReact: _react,
                            onDelete: _delete,
                            onReport: _report,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (post != null)
                // Live membership, so joining from here unlocks the box.
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _isGuest
                      ? null
                      : UserService.instance.userDoc(widget.user.uid),
                  builder: (context, userSnap) {
                    final data = userSnap.data?.data() ?? widget.profile;
                    final joined =
                        List<String>.from(data['joinedHubs'] ?? const []);
                    return _Composer(
                  isGuest: _isGuest,
                  isMember: joined.contains(post.hubId),
                  hubName: post.hubName,
                  controller: _input,
                  anonymous: _anonymous,
                  sending: _sending,
                  onToggleAnonymous: () =>
                      setState(() => _anonymous = !_anonymous),
                  onSend: _send,
                  onGuest: () =>
                      showGuestPrompt(context, action: 'join the conversation'),
                  onJoin: () => openHub(context, widget.user, post.hubId),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Thread extends StatelessWidget {
  const _Thread({
    required this.user,
    required this.post,
    required this.onReact,
    required this.onDelete,
    required this.onReport,
  });

  final User user;
  final Post post;
  final void Function(Reaction reaction, Reaction? current) onReact;
  final ValueChanged<Comment> onDelete;
  final ValueChanged<ReportTarget> onReport;

  @override
  Widget build(BuildContext context) {
    final guest = user.isAnonymous;
    return StreamBuilder<Map<String, Reaction>>(
      stream: guest ? null : PostService.instance.myReactions(user.uid),
      builder: (context, reactSnap) {
        return StreamBuilder<Set<String>>(
          stream: guest ? null : PostService.instance.myCommentIds(user.uid),
          builder: (context, mineSnap) {
            final mine = mineSnap.data ?? const <String>{};
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostCard(
                  post: post,
                  myReaction: reactSnap.data?[post.id],
                  onReact: (r) => onReact(r, reactSnap.data?[post.id]),
                  onComment: () {},
                ),
                const SizedBox(height: 20),
                StreamBuilder<Map<String, String>>(
                  stream: guest
                      ? Stream.value(const <String, String>{})
                      : BlockService.instance.blocked(user.uid),
                  builder: (context, blockSnap) {
                    final blocked = blockSnap.data ?? const <String, String>{};
                    return StreamBuilder<List<Comment>>(
                  stream: PostService.instance.comments(post.id),
                  builder: (context, snap) {
                    final comments = (snap.data ?? const <Comment>[])
                        .where((c) =>
                            c.authorId == null || !blocked.containsKey(c.authorId))
                        .toList();
                    if (snap.hasData && comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No comments yet. Say something encouraging!',
                          textAlign: TextAlign.center,
                          style: AppText.body
                              .copyWith(color: AppColors.textMuted),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final c in comments)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _CommentTile(
                              comment: c,
                              isMine: mine.contains(c.id),
                              onDelete: () => onDelete(c),
                              onReport: () => onReport(ReportTarget(
                                type: ReportType.comment,
                                path: 'posts/${post.id}/comments/${c.id}',
                                hubId: post.hubId,
                                hubName: post.hubName,
                                postId: post.id,
                                preview: c.body,
                                authorName: c.displayName,
                              )),
                              onBlock: c.authorId == null ||
                                      c.authorId == user.uid ||
                                      guest
                                  ? null
                                  : () => confirmBlock(context,
                                      uid: user.uid,
                                      targetId: c.authorId!,
                                      name: c.displayName),
                            ),
                          ),
                      ],
                    );
                  },
                );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.isMine,
    required this.onDelete,
    required this.onReport,
    this.onBlock,
  });

  final Comment comment;
  final bool isMine;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final VoidCallback? onBlock;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            initials: comment.initials,
            anonymous: comment.anonymous,
            size: 34,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isMine
                            ? '${comment.displayName} (you)'
                            : comment.displayName,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Text('  ·  ${timeAgo(comment.createdAt)}',
                        style: AppText.caption
                            .copyWith(color: AppColors.textSubtle)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(comment.body, style: AppText.body),
              ],
            ),
          ),
          if (isMine)
            IconButton(
              tooltip: 'Delete comment',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded,
                  size: 20, color: AppColors.textSubtle),
            )
          else
            PopupMenuButton<String>(
              tooltip: 'Comment options',
              icon: const Icon(Icons.more_vert_rounded,
                  size: 20, color: AppColors.textSubtle),
              onSelected: (v) => v == 'block' ? onBlock!() : onReport(),
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'report', child: Text('Report comment')),
                if (onBlock != null)
                  PopupMenuItem(
                      value: 'block',
                      child: Text('Block ${comment.displayName}')),
              ],
            ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.isGuest,
    required this.isMember,
    required this.hubName,
    required this.controller,
    required this.anonymous,
    required this.sending,
    required this.onToggleAnonymous,
    required this.onSend,
    required this.onGuest,
    required this.onJoin,
  });

  final bool isGuest;
  final bool isMember;
  final String hubName;
  final TextEditingController controller;
  final bool anonymous;
  final bool sending;
  final VoidCallback onToggleAnonymous;
  final VoidCallback onSend;
  final VoidCallback onGuest;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (isGuest) {
      content = AppButton(
          label: 'Create an account to comment', onPressed: onGuest);
    } else if (!isMember) {
      content = AppButton(
        label: 'Join $hubName to reply',
        type: AppButtonType.secondary,
        onPressed: onJoin,
      );
    } else {
      final canSend = controller.text.trim().isNotEmpty && !sending;
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: anonymous
                    ? 'Commenting anonymously (tap to show your name)'
                    : 'Comment anonymously',
                onPressed: onToggleAnonymous,
                style: IconButton.styleFrom(
                  backgroundColor:
                      anonymous ? AppColors.primaryTint : Colors.transparent,
                ),
                icon: Icon(
                  anonymous ? Icons.shield_rounded : Icons.shield_outlined,
                  color: anonymous ? AppColors.primary : AppColors.textMuted,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.body,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: anonymous
                        ? 'Comment anonymously…'
                        : 'Write something supportive…',
                    hintStyle:
                        AppText.body.copyWith(color: AppColors.textSubtle),
                    filled: true,
                    fillColor: AppColors.bg,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                tooltip: 'Send',
                onPressed: canSend ? onSend : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primarySoft,
                ),
                icon: sending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
              ),
            ],
          ),
          if (anonymous)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text('Your name won’t be shown on this comment',
                  style: AppText.label.copyWith(color: AppColors.primary)),
            ),
        ],
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: content,
        ),
      ),
    );
  }
}
