import 'package:flutter/material.dart';

import '../models/post.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

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
  });

  final Post post;
  final Reaction? myReaction;
  final bool isMine;
  final ValueChanged<Reaction> onReact;
  final VoidCallback onComment;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Avatar(
                initials: post.initials,
                anonymous: post.anonymous,
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
                            isMine
                                ? '${post.displayName} (you)'
                                : post.displayName,
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
              if (isMine && onDelete != null)
                PopupMenuButton<String>(
                  tooltip: 'Post options',
                  icon: const Icon(Icons.more_vert_rounded,
                      color: AppColors.textSubtle),
                  onSelected: (_) => onDelete!(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'delete', child: Text('Delete post')),
                  ],
                ),
            ],
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
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                for (final r in Reaction.values)
                  Expanded(
                    child: _ActionButton(
                      icon: myReaction == r ? r.selectedIcon : r.icon,
                      label: r.label,
                      count: post.counts[r] ?? 0,
                      selected: myReaction == r,
                      onTap: () => onReact(r),
                    ),
                  ),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Comment',
                    count: post.commentCount,
                    selected: false,
                    onTap: onComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Round initials avatar, or a shield for anonymous authors.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.initials,
    required this.anonymous,
    this.size = 44,
  });

  final String initials;
  final bool anonymous;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: anonymous ? AppColors.primaryTint : AppColors.accentTint,
        shape: BoxShape.circle,
      ),
      child: anonymous
          ? Icon(Icons.shield_outlined,
              size: size * 0.5, color: AppColors.primary)
          : Text(initials,
              style: AppText.bodyStrong.copyWith(
                  fontWeight: FontWeight.w700, fontSize: size * 0.34)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textMuted;
    return Semantics(
      button: true,
      selected: selected,
      label: '$label, $count',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Material(
          color: selected ? AppColors.primaryTint : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 44,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 17, color: color),
                      const SizedBox(width: 5),
                      Text(
                        count > 0 ? '$label $count' : label,
                        style: AppText.caption.copyWith(
                          color: color,
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
