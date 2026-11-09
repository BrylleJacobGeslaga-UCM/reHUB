import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';

/// Shown after sign-up until the person clicks the link in their email.
/// AuthGate moves on automatically once they're verified.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.user});

  final User user;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _poll;
  Timer? _cooldownTimer;
  int _cooldown = 60; // sign-up just sent one, so start waiting
  bool _checking = false;
  bool _resending = false;

  @override
  void initState() {
    super.initState();
    _startCooldown();
    // Quietly check every 5 seconds so the app continues by itself.
    _poll = Timer.periodic(const Duration(seconds: 5), (_) => _check());
  }

  @override
  void dispose() {
    _poll?.cancel();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = 60);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _cooldown--);
      if (_cooldown <= 0) t.cancel();
    });
  }

  Future<bool> _check() async {
    try {
      return await AuthService.instance.refreshVerification();
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkNow() async {
    setState(() => _checking = true);
    final ok = await _check();
    if (!mounted) return;
    setState(() => _checking = false);
    if (!ok) {
      _show('Not verified yet. Tap the link in the email, then try again.');
    }
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    try {
      await AuthService.instance.resendVerification();
      _show('Sent! Check your inbox (and the spam folder).');
      _startCooldown();
    } on FirebaseAuthException catch (e) {
      _show(e.code == 'too-many-requests'
          ? 'Too many emails sent. Please wait a few minutes.'
          : 'Couldn’t send the email. Try again.');
    } catch (_) {
      _show('Couldn’t send the email. Try again.');
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _differentEmail() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Use a different email?'),
        content: const Text(
            'This unconfirmed account will be removed, and you can sign up '
            'again with the right address.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove account',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok == true) await AuthService.instance.deleteUnverifiedAccount();
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.user.email ?? 'your email';

    return BottomActionLayout(
      action: AppButton(
        label: 'I’ve verified my email',
        loading: _checking,
        onPressed: _checkNow,
      ),
      children: [
        const ScreenHeader(
          title: 'Check your email',
          subtitle: 'One quick step to keep reHUB safe',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(
                child: IconTile(icon: Icons.mark_email_unread_outlined, size: 80),
              ),
              const SizedBox(height: 20),
              Text('We sent a link to', textAlign: TextAlign.center,
                  style: AppText.body.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Text(email, textAlign: TextAlign.center, style: AppText.title),
              const SizedBox(height: 12),
              Text(
                'Tap the link in that email to confirm it’s really yours. '
                'This page will continue on its own once you do.',
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              AppCard(
                color: AppColors.accentTint,
                bordered: false,
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        size: 20, color: AppColors.primaryStrong),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Can’t find it? Check your Spam or Promotions folder. '
                        'It comes from a “noreply” Firebase address.',
                        style: AppText.caption,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                label: _cooldown > 0
                    ? 'Resend email in ${_cooldown}s'
                    : 'Resend email',
                type: AppButtonType.secondary,
                loading: _resending,
                onPressed: _cooldown > 0 ? null : _resend,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _differentEmail,
                    child: Text('Use a different email',
                        style: AppText.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ),
                  Text('·',
                      style: AppText.caption
                          .copyWith(color: AppColors.textSubtle)),
                  TextButton(
                    onPressed: () => AuthService.instance.signOut(),
                    child: Text('Sign out',
                        style: AppText.caption.copyWith(
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
