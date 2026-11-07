import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';
import 'goals_page.dart';
import 'greeting_page.dart';
import 'interests_page.dart';

/// Greeting → Interests → Goals. Keeps the choices in memory and saves
/// them to Firestore at the end. AuthGate then moves on automatically.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key, required this.user});

  final User user;

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _page = 0;
  final Set<String> _interests = {};
  final Set<String> _goals = {};
  bool _saving = false;

  void _go(int page) => setState(() => _page = page);

  void _toggle(Set<String> set, String id) {
    setState(() {
      if (!set.remove(id)) set.add(id);
    });
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    try {
      await UserService.instance.completeOnboarding(
        user: widget.user,
        interests: _interests.toList(),
        goals: _goals.toList(),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Couldn’t save your choices. Check your connection '
                'and try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget page = switch (_page) {
      0 => GreetingPage(key: const ValueKey(0), onNext: () => _go(1)),
      1 => InterestsPage(
          key: const ValueKey(1),
          selected: _interests,
          onToggle: (id) => _toggle(_interests, id),
          onBack: () => _go(0),
          onNext: () => _go(2),
        ),
      _ => GoalsPage(
          key: const ValueKey(2),
          selected: _goals,
          onToggle: (id) => _toggle(_goals, id),
          onBack: () => _go(1),
          onFinish: _finish,
          saving: _saving,
        ),
    };

    // The phone's back button goes to the previous step instead of
    // leaving the app.
    return PopScope(
      canPop: _page == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _page > 0 && !_saving) _go(_page - 1);
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: page,
      ),
    );
  }
}
