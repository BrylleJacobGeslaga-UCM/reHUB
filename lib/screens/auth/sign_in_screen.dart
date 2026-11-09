import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_hero.dart';
import '../../widgets/or_divider.dart';
import '../../widgets/splash_intro.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _guestLoading = false;
  final _heroKey = GlobalKey();
  final _logoKey = GlobalKey();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService.instance.signIn(_email.text, _password.text);
      // AuthGate switches screens automatically once signed in.
    } catch (e) {
      _show(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _guest() async {
    setState(() => _guestLoading = true);
    try {
      await AuthService.instance.continueAsGuest();
    } catch (e) {
      _show(AuthService.messageFor(e));
    } finally {
      if (mounted) setState(() => _guestLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _email.text.trim();
    if (!email.contains('@')) {
      _show('Type your email above first, then tap “Forgot password?”.');
      return;
    }
    try {
      await AuthService.instance.sendPasswordReset(email);
      _show('If an account exists for $email, a reset link is on its way.');
    } catch (e) {
      _show(AuthService.messageFor(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashIntro(
        heroKey: _heroKey,
        logoKey: _logoKey,
        child: (intro) => SingleChildScrollView(
        child: Column(
          children: [
            AuthHero(
              key: _heroKey,
              logoKey: _logoKey,
              title: 'Welcome back',
              subtitle: 'Rebuild with support, one day at a time.',
            ),
            _FadeUp(
              progress: intro,
              child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.mail_outline_rounded,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                      controller: _password,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter your password'
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          'Forgot password?',
                          style: AppText.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    AppButton(
                        label: 'Sign in', onPressed: _signIn, loading: _loading),
                    const SizedBox(height: 8),
                    SwitchAuthRow(
                      question: 'New to reHUB?',
                      action: 'Create an account',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const SignUpScreen()),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const OrDivider(),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Continue as guest',
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
            ),
          ],
        ),
        ),
      ),
    );
  }
}

/// Fades the form in and lifts it slightly during the second half of the
/// splash intro. Shows it straight away when there's no intro.
class _FadeUp extends StatelessWidget {
  const _FadeUp({required this.progress, required this.child});

  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: progress,
      curve: const Interval(0.55, 0.95, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, 0.12), end: Offset.zero)
            .animate(curved),
        child: child,
      ),
    );
  }
}
