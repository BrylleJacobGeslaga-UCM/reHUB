import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/bottom_action.dart';

class GreetingPage extends StatelessWidget {
  const GreetingPage({super.key, required this.onNext});

  final VoidCallback onNext;

  static const _features = [
    (Icons.groups_outlined, 'Join hubs built around activities you enjoy'),
    (Icons.sentiment_satisfied_outlined, 'Check in with how you’re feeling each day'),
    (Icons.favorite_border_rounded, 'Share progress and cheer others on'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomActionLayout(
      action: AppButton(label: 'Get started', showIcon: true, onPressed: onNext),
      children: [
        const _GreetingHero(),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to reHUB', style: AppText.display),
              const SizedBox(height: 8),
              Text('Find support. Build better habits.',
                  style: AppText.title.copyWith(color: AppColors.primary)),
              const SizedBox(height: 12),
              Text(
                'A safe space to stay consistent through daily check-ins, '
                'supportive communities, and healthy activities.',
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              for (final (icon, text) in _features)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, size: 18, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(text, style: AppText.bodyStrong)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GreetingHero extends StatelessWidget {
  const _GreetingHero();

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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      child: Container(
        color: AppColors.primary,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(top: -70, right: -60, child: _circle(220)),
            Positioned(top: 160, left: -40, child: _circle(120)),
            SafeArea(
              bottom: false,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/logo.svg',
                          width: 104, height: 104),
                    ),
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
