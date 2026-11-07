import 'package:flutter/material.dart';

import '../../models/onboarding_options.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';

class InterestsPage extends StatelessWidget {
  const InterestsPage({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onBack,
    required this.onNext,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final count = selected.length;

    return BottomActionLayout(
      footer: Text(
        count == 0 ? 'Pick at least one' : '$count selected',
        style: AppText.caption.copyWith(color: AppColors.textMuted),
      ),
      action: AppButton(
        label: 'Continue',
        showIcon: true,
        onPressed: count == 0 ? null : onNext,
      ),
      children: [
        ScreenHeader(
          title: 'What are your interests?',
          subtitle: 'Pick activities you enjoy or want to explore. '
              'We’ll suggest hubs to match.',
          step: 'Step 1 of 2',
          onBack: onBack,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.55,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final o in interestOptions)
                _InterestTile(
                  option: o,
                  selected: selected.contains(o.id),
                  onTap: () => onToggle(o.id),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InterestTile extends StatelessWidget {
  const _InterestTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Option option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.border,
        width: selected ? 2 : 1,
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.primaryTint : AppColors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.surface
                            : AppColors.primaryTint,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(option.icon,
                          size: 26, color: AppColors.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      option.label,
                      style: AppText.bodyStrong.copyWith(
                        color: selected
                            ? AppColors.primaryStrong
                            : AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
