import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

/// Friendly placeholder for screens with nothing to show yet.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 48, 32, 24),
      child: Column(
        children: [
          IconTile(icon: icon, size: 72),
          const SizedBox(height: 20),
          Text(title, textAlign: TextAlign.center, style: AppText.heading),
          const SizedBox(height: 8),
          Text(message,
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.textMuted)),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }
}
