import 'package:flutter/material.dart';

import '../models/avatar.dart';
import '../models/post.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';
import 'author.dart';
import 'pop.dart';

/// Matches the Figma "Post Card" component.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onReact,
    required this.onComment,
    this.myReaction,
    this.isMine = false,
    this.onDelete,
    this.onReport,
    this.onBlock,
  });

  final Post post;
  final Reaction? myReaction;
  final bool isMine;
  final ValueChanged<Reaction> onReact;
  final VoidCallback onComment;
  final VoidCallback? onDelete;
  final VoidCallback? onReport;

  /// Only offered on named posts by someone else.
  final VoidCallback? onBlock;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthorBuilder(
            uid: post.anonymous ? null : post.authorId,
            name: post.displayName,
            avatar: post.authorAvatar,
            builder: (context, name, avatar) => Row(
            children: [
              Avatar(
                initials: initialsOf(name),
                anonymous: post.anonymous,
                avatar: avatar,
                size: 44,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            isMine ? '$name (you)' : name,
                            style: AppText.bodyStrong,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text('  ·  ${timeAgo(post.createdAt)}',
                            style: AppText.caption
                                .copyWith(color: AppColors.textSubtle)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTint,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(post.hubName,
                          style:
                              AppText.label.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              if ((isMine && onDelete != null) || (!isMine && onReport != null))
                PopupMenuButton<String>(
                  tooltip: 'Post options',
                  icon: const Icon(Icons.more_vert_rounded,
                      color: AppColors.textSubtle),
                  onSelected: (v) => switch (v) {
                    'delete' => onDelete!(),
                    'block' => onBlock!(),
                    _ => onReport!(),
                  },
                  itemBuilder: (_) => [
                    if (isMine)
                      const PopupMenuItem(
                          value: 'delete', child: Text('Delete post'))
                    else ...[
                      const PopupMenuItem(
                          value: 'report', child: Text('Report post')),
                      if (onBlock != null && post.authorId != null)
                        PopupMenuItem(
                            value: 'block',
                            child: Text('Block $name')),
                    ],
                  ],
                ),
            ],
          ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 8, 12),
            child: Text(post.body, style: AppText.body),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Divider(height: 1, color: AppColors.border),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 8, top: 4),
            child: Row(
              children: [
                // Reactions on the left. If the screen is narrow the whole
                // group shrinks evenly, so every chip stays the same size.
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        for (final r in Reaction.values) ...[
                          if (r != Reaction.values.first)
                            const SizedBox(width: 6),
                          _ReactionChip(
                            icon: myReaction == r ? r.selectedIcon : r.icon,
                            label: r.label,
                            count: post.counts[r] ?? 0,
                            selected: myReaction == r,
                            onTap: () => onReact(r),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Comments on the right: just the bubble and the count.
                _ReactionChip(
                  icon: Icons.chat_bubble_outline_rounded,
                  count: post.commentCount,
                  selected: false,
                  plain: true,
                  semanticsLabel: 'Comments',
                  onTap: onComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Round avatar: the person's chosen icon and color, their initials if they
/// haven't picked one, or a shield for anonymous authors.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.initials,
    required this.anonymous,
    this.avatar,
    this.size = 44,
  });

  final String initials;
  final bool anonymous;
  final AvatarStyle? avatar;
  final double size;

  @override
  Widget build(BuildContext context) {
    final style = anonymous ? null : avatar;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: anonymous
            ? AppColors.primaryTint
            : style?.color.background ?? AppColors.accentTint,
        shape: BoxShape.circle,
      ),
      child: anonymous
          ? Icon(Icons.shield_outlined,
              size: size * 0.5, color: AppColors.primary)
          : style != null
              ? Icon(style.icon,
                  size: size * 0.52, color: style.color.foreground)
              : Text(initials,
                  style: AppText.bodyStrong.copyWith(
                      fontWeight: FontWeight.w700, fontSize: size * 0.34)),
    );
  }
}

/// A rounded reaction chip: icon, label and count. The selected one is
/// filled mint; the count animates when it changes.
class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.icon,
    required this.count,
    required this.selected,
    required this.onTap,
    this.label,
    this.plain = false,
    this.semanticsLabel,
  });

  final IconData icon;
  final String? label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  /// No outline (used for the comment button).
  final bool plain;
  final String? semanticsLabel;

  static const _duration = Duration(milliseconds: 220);

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;
    final textStyle = AppText.caption.copyWith(
      color: color,
      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: '${label ?? semanticsLabel ?? ''}, $count',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: _duration,
          curve: Curves.easeOut,
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryTint : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: plain
                  ? Colors.transparent
                  : selected
                      ? AppColors.primarySoft
                      : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Pop(
                active: selected,
                child: Icon(icon, size: 17, color: color),
              ),
              if (label != null) ...[
                const SizedBox(width: 5),
                Text(label!, style: textStyle),
              ],
              // The number slides up/down when it changes.
              AnimatedSwitcher(
                duration: _duration,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SizeTransition(
                    sizeFactor: anim,
                    axis: Axis.horizontal,
                    child: child,
                  ),
                ),
                child: count > 0
                    ? Padding(
                        key: ValueKey(count),
                        padding: const EdgeInsets.only(left: 6),
                        child: Text('$count',
                            style: textStyle.copyWith(
                                fontWeight: FontWeight.w800)),
                      )
                    : const SizedBox.shrink(key: ValueKey(0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
