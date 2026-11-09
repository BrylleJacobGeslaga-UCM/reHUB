import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/checkin.dart';
import '../screens/checkin/checkin_history_screen.dart';
import '../services/checkin_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

/// Profile card: check-ins this month, streak, and a link to the history.
class CheckInSummary extends StatelessWidget {
  const CheckInSummary({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CheckIn>>(
      stream: CheckInService.instance.history(user.uid),
      builder: (context, snap) {
        final all = snap.data ?? const <CheckIn>[];
        final now = DateTime.now();
        final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
        final thisMonth = all
            .where((c) => c.date.year == now.year && c.date.month == now.month)
            .length;
        final streak = CheckInService.streak(all);

        return AppCard(
          onTap: () => openCheckInHistory(context, user),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.trending_up_rounded,
                      color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text('Daily check-ins', style: AppText.bodyStrong)),
                  Text('$thisMonth',
                      style: AppText.title
                          .copyWith(color: AppColors.primaryStrong)),
                  Text(' / $daysInMonth days',
                      style: AppText.caption
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                // Fills up smoothly when it appears and after each check-in.
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: thisMonth / daysInMonth),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryTint,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      streak == 0
                          ? 'Check in today to start a streak.'
                          : streak == 1
                              ? '1-day streak. Keep it going!'
                              : '$streak-day streak. You’re doing great.',
                      style:
                          AppText.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                  Text('View history',
                      style: AppText.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                  const Icon(Icons.chevron_right_rounded,
                      size: 18, color: AppColors.primary),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
