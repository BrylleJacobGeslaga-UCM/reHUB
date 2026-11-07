import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/checkin.dart';
import '../screens/checkin/checkin_history_screen.dart';
import '../screens/checkin/checkin_screen.dart';
import '../services/checkin_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'sheets.dart';

/// The daily check-in card on Home. Changes once you've checked in today.
class CheckInCard extends StatelessWidget {
  const CheckInCard({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    if (user.isAnonymous) {
      return _NotDone(
        onCheckIn: () => showGuestPrompt(context, action: 'check in'),
      );
    }

    return StreamBuilder<CheckIn?>(
      stream: CheckInService.instance.today(user.uid),
      builder: (context, snap) {
        final today = snap.data;
        if (today == null) {
          return _NotDone(onCheckIn: () => openCheckIn(context, user));
        }
        return AppCard(
          color: AppColors.primaryTint,
          bordered: false,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color: today.mood.color, shape: BoxShape.circle),
                    child: Icon(today.mood.icon,
                        color: today.mood.onColor, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('You checked in today', style: AppText.title),
                        Text(
                          'Feeling ${today.mood.label.toLowerCase()}. '
                          'See you tomorrow!',
                          style: AppText.caption
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Edit',
                      type: AppButtonType.secondary,
                      onPressed: () =>
                          openCheckIn(context, user, existing: today),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: AppButton(
                      label: 'History',
                      type: AppButtonType.secondary,
                      onPressed: () => openCheckInHistory(context, user),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NotDone extends StatelessWidget {
  const _NotDone({required this.onCheckIn});
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.accentTint,
      bordered: false,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const IconTile(
                icon: Icons.sentiment_satisfied_outlined,
                size: 52,
                color: AppColors.surface,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Daily check-in', style: AppText.title),
                    Text(
                      'How are you feeling today? It takes under a minute.',
                      style:
                          AppText.caption.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          AppButton(label: 'Check in now', showIcon: true, onPressed: onCheckIn),
        ],
      ),
    );
  }
}
