import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/account_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';

void openDeleteAccount(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const DeleteAccountScreen()),
  );
}

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _password = TextEditingController();
  bool _understood = false;
  bool _deleting = false;
  String? _step;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() {
      _deleting = true;
      _step = null;
    });
    try {
      await AccountService.instance.deleteAccount(
        password: _password.text,
        onStep: (s) {
          if (mounted) setState(() => _step = s);
        },
      );
      // Signed out automatically; AuthGate shows the Sign In screen.
      navigator.popUntil((r) => r.isFirst);
      messenger.showSnackBar(const SnackBar(
          content: Text('Your account was deleted. Take care of yourself.')));
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'wrong-password' || 'invalid-credential' => 'That password isn’t right.',
        'too-many-requests' => 'Too many attempts. Please wait and try again.',
        'network-request-failed' => 'No internet connection.',
        _ => 'Couldn’t delete your account. Try again.',
      };
      messenger.showSnackBar(SnackBar(content: Text(msg)));
      if (mounted) setState(() => _deleting = false);
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Couldn’t delete your account. Try again.')));
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const removed = [
      'Your profile, interests and goals',
      'All your check-ins and My plan',
      'Your posts and comments (anonymous ones too)',
      'Your reactions, RSVPs and chat messages',
      'Your hub memberships',
    ];

    return PopScope(
      canPop: !_deleting,
      child: BottomActionLayout(
        footer: _step == null
            ? null
            : Text(_step!,
                style: AppText.caption.copyWith(color: AppColors.textMuted)),
        action: AppButton(
          label: 'Delete my account',
          type: AppButtonType.danger,
          loading: _deleting,
          onPressed: (_understood && _password.text.isNotEmpty && !_deleting)
              ? _delete
              : null,
        ),
        children: [
          ScreenHeader(
            title: 'Delete account',
            subtitle: 'This can’t be undone',
            onBack: _deleting ? null : () => Navigator.of(context).pop(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('What will be deleted', style: AppText.title),
                const SizedBox(height: 10),
                AppCard(
                  child: Column(
                    children: [
                      for (final r in removed)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.remove_circle_outline_rounded,
                                  size: 18, color: AppColors.danger),
                              const SizedBox(width: 10),
                              Expanded(child: Text(r, style: AppText.body)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Reports you made stay with the admins so they can finish '
                  'reviewing them, but they won’t show your name.',
                  style: AppText.caption.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                AppCard(
                  color: AppColors.accentTint,
                  bordered: false,
                  onTap: () => showHelpSheet(context),
                  child: Row(
                    children: [
                      const Icon(Icons.support_outlined,
                          color: AppColors.primaryStrong),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Leaving because things feel heavy right now? You '
                          'don’t have to go through it alone. Tap for free, '
                          '24/7 support.',
                          style: AppText.caption,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Confirm with your password',
                  hint: 'Your password',
                  icon: Icons.lock_outline_rounded,
                  controller: _password,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
                  onTap: _deleting
                      ? null
                      : () => setState(() => _understood = !_understood),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _understood,
                        activeColor: AppColors.danger,
                        onChanged: _deleting
                            ? null
                            : (v) => setState(() => _understood = v ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'I understand this permanently deletes my account '
                          'and data.',
                          style: AppText.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
