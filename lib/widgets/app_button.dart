import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum AppButtonType { primary, secondary, danger }

/// Full-width button matching the Figma "Button" component.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.showIcon = false,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool showIcon;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, Color? border) = switch (type) {
      AppButtonType.primary => (AppColors.primary, Colors.white, null),
      AppButtonType.secondary =>
        (AppColors.surface, AppColors.primary, AppColors.primarySoft),
      AppButtonType.danger =>
        (AppColors.surface, AppColors.danger, AppColors.border),
    };

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        onPressed: loading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          disabledBackgroundColor: bg.withValues(alpha: 0.7),
          disabledForegroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: border == null
                ? BorderSide.none
                : BorderSide(color: border, width: 1.5),
          ),
          textStyle: AppText.bodyStrong.copyWith(fontWeight: FontWeight.w700),
        ),
        child: loading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(label),
                  if (showIcon) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
