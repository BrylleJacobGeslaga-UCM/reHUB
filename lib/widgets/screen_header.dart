import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// The green header used on most screens: optional back button and step
/// chip, a big title, optional subtitle, rounded bottom corners.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.step,
    this.trailing,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? step;
  final Widget? trailing;

  /// Small icon buttons shown at the top right (e.g. settings).
  final List<Widget> actions;

  Widget _circle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final hasTopRow = onBack != null || step != null || actions.isNotEmpty;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        color: AppColors.primary,
        child: Stack(
          children: [
            Positioned(top: -70, right: -60, child: _circle(220)),
            Positioned(top: 140, left: -40, child: _circle(120)),
            SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, hasTopRow ? 16 : 32, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasTopRow)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              if (onBack != null)
                                HeaderIconButton(
                                  icon: Icons.arrow_back_rounded,
                                  tooltip: 'Back',
                                  onTap: onBack!,
                                ),
                              const Spacer(),
                              if (step != null) _StepChip(step!),
                              for (final a in actions) ...[
                                const SizedBox(width: 8),
                                a,
                              ],
                            ],
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                    style: AppText.display
                                        .copyWith(color: Colors.white)),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 6),
                                  Text(
                                    subtitle!,
                                    style: AppText.body.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.82),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (trailing != null) ...[
                            const SizedBox(width: 12),
                            trailing!,
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Round translucent button for use on the green header.
class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 40,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.14),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: Colors.white, size: size * 0.55),
          ),
        ),
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: AppText.label.copyWith(color: Colors.white)),
    );
  }
}
