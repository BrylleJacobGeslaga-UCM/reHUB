import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'pop.dart';

class _Tab {
  const _Tab(this.label, this.icon, this.activeIcon);
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

const _tabs = [
  _Tab('Home', Icons.home_outlined, Icons.home_rounded),
  _Tab('Feed', Icons.article_outlined, Icons.article_rounded),
  _Tab('Chat', Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded),
  _Tab('Profile', Icons.person_outline_rounded, Icons.person_rounded),
];

const _pillWidth = 64.0;
const _pillHeight = 32.0;
const _slide = Duration(milliseconds: 320);

/// Bottom navigation. One mint pill slides over to the tab you tap.
class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.index, required this.onTap});

  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
          child: LayoutBuilder(
            builder: (context, box) {
              final slot = box.maxWidth / _tabs.length;
              return Stack(
                children: [
                  // The sliding pill, drawn behind the icons.
                  AnimatedPositioned(
                    duration: _slide,
                    curve: Curves.easeOutBack,
                    top: 4,
                    left: slot * index + (slot - _pillWidth) / 2,
                    width: _pillWidth,
                    height: _pillHeight,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primaryTint,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < _tabs.length; i++)
                        Expanded(
                          child: _NavItem(
                            tab: _tabs[i],
                            active: i == index,
                            onTap: () => onTap(i),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.tab, required this.active, required this.onTap});

  final _Tab tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: tab.label,
      excludeSemantics: true,
      // No grey ripple: the sliding pill is the feedback.
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: _pillHeight,
                child: Center(
                  child: Pop(
                    active: active,
                    child: TweenAnimationBuilder<Color?>(
                      tween: ColorTween(
                          end: active ? AppColors.primary : AppColors.textMuted),
                      duration: _slide,
                      builder: (context, color, _) => Icon(
                        active ? tab.activeIcon : tab.icon,
                        size: 24,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: _slide,
                style: AppText.caption.copyWith(
                  color: active ? AppColors.primary : AppColors.textMuted,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(tab.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
