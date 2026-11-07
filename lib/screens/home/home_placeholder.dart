import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/onboarding_options.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../auth/sign_up_screen.dart';

/// Temporary screen showing the saved profile. Replaced by the real
/// Home screen with bottom navigation in step 4.
class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    final isGuest = user.isAnonymous;
    final name = isGuest
        ? 'Guest'
        : (profile['name'] as String?) ?? user.displayName ?? 'there';
    final interests = List<String>.from(profile['interests'] ?? const []);
    final goals = List<String>.from(profile['goals'] ?? const []);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Center(
                  child: SvgPicture.asset('assets/logo.svg',
                      width: 72, height: 72)),
              const SizedBox(height: 20),
              Text('Hi, $name!',
                  style: AppText.display, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                isGuest
                    ? 'You’re browsing as a guest. Create an account to '
                        'join hubs, post and check in.'
                    : 'Onboarding saved. The real Home screen comes next.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
              if (!isGuest) ...[
                const SizedBox(height: 28),
                Text('Your interests', style: AppText.title),
                const SizedBox(height: 10),
                _Chips(labels: [
                  for (final id in interests) labelFor(interestOptions, id)
                ]),
                const SizedBox(height: 20),
                Text('Your goals', style: AppText.title),
                const SizedBox(height: 10),
                _Chips(labels: [
                  for (final id in goals) labelFor(goalOptions, id)
                ]),
              ],
              const SizedBox(height: 32),
              if (isGuest) ...[
                AppButton(
                  label: 'Create an account',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: isGuest ? 'Leave guest mode' : 'Sign out',
                type: AppButtonType.secondary,
                onPressed: () => AuthService.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({required this.labels});
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final l in labels)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(l,
                style: AppText.caption.copyWith(fontWeight: FontWeight.w600)),
          ),
      ],
    );
  }
}
