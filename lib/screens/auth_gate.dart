import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/splash_intro.dart';
import 'auth/sign_in_screen.dart';
import 'auth/verify_email_screen.dart';
import 'shell/app_shell.dart';
import 'onboarding/onboarding_flow.dart';

/// Decides what to show:
/// logged out → Sign In, guest → app (browse-only),
/// unverified → Verify email, not onboarded yet → Onboarding, otherwise → app.
///
/// Every change is a smooth crossfade (see [_GateSwitch]).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  StreamSubscription<User?>? _authSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _docSub;

  bool _authKnown = false;
  User? _user;
  String? _docFor; // uid the profile below belongs to
  Map<String, dynamic>? _profile;
  bool _profileLoaded = false;
  Object? _profileError;

  // What's on screen now. Kept while a new profile loads, so signing in
  // goes straight from Sign In to Home without a blank screen in between.
  String? _shownId;
  Widget? _shown;

  @override
  void initState() {
    super.initState();
    _authSub = AuthService.instance.userChanges.listen(_onUser);
  }

  void _onUser(User? user) {
    final needsDoc = user != null && !user.isAnonymous && user.emailVerified;
    if (!needsDoc || user.uid != _docFor) {
      _docSub?.cancel();
      _docSub = null;
      _docFor = null;
      _profile = null;
      _profileLoaded = false;
      _profileError = null;
    }
    if (needsDoc && _docSub == null) {
      _docFor = user.uid;
      _docSub = UserService.instance.userDoc(user.uid).listen(
        (snap) => setState(() {
          _profile = snap.data();
          _profileLoaded = true;
          _profileError = null;
        }),
        onError: (Object e) => setState(() => _profileError = e),
      );
    }
    setState(() {
      _authKnown = true;
      _user = user;
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _docSub?.cancel();
    super.dispose();
  }

  /// The screen for the current state, with an id that only changes when
  /// the kind of screen changes. Null while the profile is still loading.
  (String, Widget)? _current() {
    final user = _user;
    if (user == null) return ('signin', const SignInScreen());

    // Guests are browse-only: no onboarding, nothing saved.
    if (user.isAnonymous) {
      return ('guest-${user.uid}', AppShell(user: user, profile: const {}));
    }

    // Real accounts must confirm their email before using the app.
    if (!user.emailVerified) {
      return ('verify-${user.uid}', VerifyEmailScreen(user: user));
    }

    if (_profileError != null) {
      return ('error', _ErrorScreen(message: _profileError.toString()));
    }
    if (!_profileLoaded) return null;

    final profile = _profile;
    if (profile == null || profile['onboarded'] != true) {
      return ('onboarding-${user.uid}', OnboardingFlow(user: user));
    }
    return ('app-${user.uid}', AppShell(user: user, profile: profile));
  }

  @override
  Widget build(BuildContext context) {
    if (!_authKnown) return const _Loading();

    final current = _current();
    if (current != null) {
      _shownId = current.$1;
      _shown = _ready(current.$2);
    }
    // Nothing to show yet (first launch, profile loading): the native splash
    // is still covering the screen.
    if (_shown == null) return const _Loading();

    return _GateSwitch(id: _shownId!, child: _shown!);
  }
}

/// Hides the native splash screen the first time a real screen is ready.
Widget _ready(Widget screen) {
  FlutterNativeSplash.remove();
  // The splash intro only belongs to a launch that opens on Sign In.
  if (screen is! SignInScreen) SplashIntro.skip();
  return screen;
}

/// Crossfades between the gate's screens (sign in → home, sign out,
/// onboarding → home…) with a slight zoom, instead of an instant swap.
///
/// The old screen holds for a moment first, so the Sign in button's ✓ can be
/// seen, then fades while the new one fades and grows into place. Both have
/// a green header at the top, so the header appears to reshape.
class _GateSwitch extends StatelessWidget {
  const _GateSwitch({required this.id, required this.child});

  /// Only a change of [id] animates; profile updates just rebuild in place.
  final String id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 650),
      // New screen: starts a little after the old one begins to fade.
      switchInCurve: const Interval(0.4, 1, curve: Curves.easeOutCubic),
      // Old screen: stays put for the first half, then fades.
      switchOutCurve: const Interval(0, 0.5, curve: Curves.easeIn),
      layoutBuilder: (current, previous) => Stack(
        fit: StackFit.expand,
        children: [...previous, if (current != null) current],
      ),
      transitionBuilder: (child, animation) => _GateTransition(
        animation: animation,
        child: child,
      ),
      child: KeyedSubtree(key: ValueKey(id), child: child),
    );
  }
}

class _GateTransition extends StatelessWidget {
  const _GateTransition({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      // The leaving screen can't be tapped.
      builder: (context, child) => IgnorePointer(
        ignoring: animation.status == AnimationStatus.reverse,
        child: child,
      ),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(animation),
          child: child,
        ),
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: AppColors.primary);
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
