import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/auth/sign_up_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_button.dart';
import 'app_card.dart';

/// Shared bottom-sheet frame: drag handle, rounded top, padding.
Future<void> _showSheet(BuildContext context, List<Widget> children) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    ),
  );
}

/// Shown when a guest taps something that needs an account.
Future<void> showGuestPrompt(BuildContext context, {required String action}) {
  return _showSheet(context, [
    const Center(child: IconTile(icon: Icons.lock_outline_rounded, size: 56)),
    const SizedBox(height: 16),
    Text('Create an account to $action',
        textAlign: TextAlign.center, style: AppText.heading),
    const SizedBox(height: 8),
    Text(
      'Guests can look around. With a free account you can join hubs, '
      'post updates and keep a private check-in history.',
      textAlign: TextAlign.center,
      style: AppText.body.copyWith(color: AppColors.textMuted),
    ),
    const SizedBox(height: 24),
    Builder(
      builder: (sheetContext) => AppButton(
        label: 'Create an account',
        onPressed: () {
          Navigator.of(sheetContext).pop();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          );
        },
      ),
    ),
    const SizedBox(height: 8),
    Builder(
      builder: (sheetContext) => TextButton(
        onPressed: () => Navigator.of(sheetContext).pop(),
        child: Text('Not now',
            style: AppText.bodyStrong.copyWith(color: AppColors.textMuted)),
      ),
    ),
  ]);
}

class _Hotline {
  const _Hotline(this.label, this.display, this.dial);
  final String label;
  final String display;
  final String dial;
}

// Source: DOH / NCMH Crisis Hotline, as reported Jan 2026.
const _hotlines = [
  _Hotline('Toll-free landline (nationwide)', '1553', '1553'),
  _Hotline('Globe / TM', '0917 899 8727', '09178998727'),
  _Hotline('Smart / TNT', '0919 057 1553', '09190571553'),
];

/// "Need to talk to someone?" — crisis hotlines with tap-to-call.
Future<void> showHelpSheet(BuildContext context) {
  Future<void> call(String number) async {
    final ok = await launchUrl(Uri(scheme: 'tel', path: number));
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn’t start a call. Dial $number directly.')),
      );
    }
  }

  return _showSheet(context, [
    const Center(
      child: IconTile(
        icon: Icons.support_outlined,
        size: 56,
        color: AppColors.accentTint,
        iconColor: AppColors.primaryStrong,
      ),
    ),
    const SizedBox(height: 16),
    Text('You don’t have to go through this alone',
        textAlign: TextAlign.center, style: AppText.heading),
    const SizedBox(height: 8),
    Text(
      'The NCMH Crisis Hotline is free, confidential and open 24/7. '
      'Trained responders can help with stress, cravings, relapse '
      'or thoughts of self-harm.',
      textAlign: TextAlign.center,
      style: AppText.body.copyWith(color: AppColors.textMuted),
    ),
    const SizedBox(height: 20),
    for (final h in _hotlines)
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AppCard(
          onTap: () => call(h.dial),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const IconTile(icon: Icons.call_outlined, size: 40),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(h.display, style: AppText.title),
                    Text(h.label,
                        style: AppText.caption
                            .copyWith(color: AppColors.textMuted)),
                  ],
                ),
              ),
              Text('Call',
                  style: AppText.bodyStrong
                      .copyWith(color: AppColors.primary)),
            ],
          ),
        ),
      ),
    const SizedBox(height: 6),
    AppCard(
      onTap: () => call('911'),
      color: AppColors.dangerTint,
      bordered: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const IconTile(
            icon: Icons.emergency_outlined,
            size: 40,
            color: AppColors.surface,
            iconColor: AppColors.danger,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text('In immediate danger? Call 911',
                style: AppText.bodyStrong.copyWith(color: AppColors.danger)),
          ),
        ],
      ),
    ),
  ]);
}
