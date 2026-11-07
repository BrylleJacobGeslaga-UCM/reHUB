import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/hub_service.dart';
import '../../widgets/bottom_nav.dart';
import '../chat/chat_screen.dart';
import '../feed/feed_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

/// The main app: four tabs with the bottom navigation bar.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Creates the starter hubs the very first time (only if none exist).
    if (!widget.user.isAnonymous) {
      HubService.instance.ensureSeeded().catchError((_) {});
    }
  }

  void _goTo(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(user: widget.user, profile: widget.profile, onGoTo: _goTo),
      FeedScreen(user: widget.user, profile: widget.profile),
      ChatScreen(user: widget.user),
      ProfileScreen(user: widget.user, profile: widget.profile),
    ];

    // Phone back button on another tab returns to Home first.
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goTo(0);
      },
      child: Scaffold(
        body: IndexedStack(index: _index, children: pages),
        bottomNavigationBar: BottomNav(index: _index, onTap: _goTo),
      ),
    );
  }
}
