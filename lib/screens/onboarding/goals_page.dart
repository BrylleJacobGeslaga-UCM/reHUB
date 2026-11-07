import 'package:flutter/material.dart';

import '../../models/onboarding_options.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({
    super.key,
    required this.selected,
    required this.onToggle,
    required this.onBack,
    required this.onFinish,
    this.saving = false,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onBack;
  final VoidCallback onFinish;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    return BottomActionLayout(
      action: AppButton(
        label: 'Continue',
        showIcon: true,
        loading: saving,
        onPressed: selected.isEmpty ? null : onFinish,
      ),
      children: [
        ScreenHeader(
          title: 'What are your goals?',
          subtitle: 'Choose what matters most right now. '
              'You can change this anytime.',
          step: 'Step 2 of 2',
          onBack: saving ? null : onBack,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            children: [
              for (final o in goalOptions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _GoalTile(
                    option: o,
                    selected: selected.contains(o.id),
                    onTap: () => onToggle(o.id),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        selected ? AppColors.surface : AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(option.icon, size: 22, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(option.label, style: AppText.title),
                      if (option.description != null)
                        Text(
                          option.description!,
                          style: AppText.caption
                              .copyWith(color: AppColors.textMuted),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                    border: selected
                        ? null
                        : Border.all(color: AppColors.border, width: 2),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          size: 14, color: Colors.white)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
