import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'auth/sign_in_screen.dart';
import 'shell/app_shell.dart';
import 'onboarding/onboarding_flow.dart';

/// Decides what to show:
/// logged out → Sign In, guest → app (browse-only),
/// not onboarded yet → Onboarding, otherwise → app.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.userChanges,
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const _Loading();
        }
        final user = authSnap.data;
        if (user == null) return const SignInScreen();

        // Guests are browse-only: no onboarding, nothing saved.
        if (user.isAnonymous) {
          return AppShell(user: user, profile: const {});
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          key: ValueKey(user.uid),
          stream: UserService.instance.userDoc(user.uid),
          builder: (context, docSnap) {
            if (docSnap.hasError) {
              return _ErrorScreen(message: docSnap.error.toString());
            }
            if (!docSnap.hasData) return const _Loading();

            final profile = docSnap.data!.data();
            if (profile == null || profile['onboarded'] != true) {
              return OnboardingFlow(user: user);
            }
            return AppShell(user: user, profile: profile);
          },
        );
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Couldn’t load your profile', style: AppText.title),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppText.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => AuthService.instance.signOut(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
