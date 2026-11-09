import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_hero.dart';
import '../../widgets/or_divider.dart';
import '../../models/blocked_domains.dart';
import '../info/guidelines_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _agreed = false;
  bool _guestLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// After success, close this screen so AuthGate's home shows underneath.
  void _closeToRoot() {
    if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.signUp(
        name: _name.text,
        email: _email.text,
        password: _password.text,
      );
      _closeToRoot();
    } catch (e) {
      _show(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// True when Sign Up was opened from guest mode.
  bool get _isGuest => AuthService.instance.currentUser?.isAnonymous ?? false;

  /// "Already have an account? Sign in". Guests leave guest mode first
  /// (they have no saved data), so AuthGate shows the Sign In screen.
  Future<void> _goToSignIn() async {
    if (_isGuest) {
      await AuthService.instance.signOut();
      _closeToRoot();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _guest() async {
    if (_isGuest) {
      // Already a guest: just go back to browsing.
      Navigator.of(context).pop();
      return;
    }
    setState(() => _guestLoading = true);
    try {
      await AuthService.instance.continueAsGuest();
      _closeToRoot();
    } catch (e) {
      _show(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _guestLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHero(
              title: 'Join reHUB',
              subtitle: 'Create an account to get started.',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Name',
                      hint: 'What should we call you?',
                      icon: Icons.person_outline_rounded,
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().length < 2)
                          ? 'Enter at least 2 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.mail_outline_rounded,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || !v.contains('@')) {
                          return 'Enter a valid email';
                        }
                        if (isBlockedEmail(v)) {
                          return 'Please use your personal email. Temporary '
                              'inboxes aren’t allowed.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      hint: 'At least 8 characters',
                      icon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v == null || v.length < 8)
                          ? 'At least 8 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreed,
                          activeColor: AppColors.primary,
                          onChanged: (v) =>
                              setState(() => _agreed = v ?? false),
                        ),
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text('I agree to the ',
                                  style: AppText.caption),
                              GestureDetector(
                                onTap: () => openGuidelines(context),
                                child: Text(
                                  'Community Guidelines',
                                  style: AppText.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(' and privacy summary.',
                                  style: AppText.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Create account',
                      onPressed: _agreed ? _createAccount : null,
                      loading: _loading,
                    ),
                    const SizedBox(height: 8),
                    SwitchAuthRow(
                      question: 'Already have an account?',
                      action: 'Sign in',
                      onTap: _goToSignIn,
                    ),
                    const SizedBox(height: 8),
                    const OrDivider(),
                    const SizedBox(height: 16),
                    AppButton(
                      label: _isGuest
                          ? 'Keep browsing as guest'
                          : 'Continue as guest',
                      type: AppButtonType.secondary,
                      onPressed: _guest,
                      loading: _guestLoading,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'reHUB is a peer-support community, not a substitute '
                      'for professional care.',
                      textAlign: TextAlign.center,
                      style: AppText.caption
                          .copyWith(color: AppColors.textSubtle),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
