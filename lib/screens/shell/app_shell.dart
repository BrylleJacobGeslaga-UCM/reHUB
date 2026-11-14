import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/hub_service.dart';
import '../../services/public_profile_service.dart';
import '../../services/reminder_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/bottom_nav.dart';
import '../../widgets/milestone_watcher.dart';
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
  final _pages = PageController();

  @override
  void initState() {
    super.initState();
    // Creates the starter hubs the very first time (only if none exist).
    if (!widget.user.isAnonymous) {
      HubService.instance.ensureSeeded().catchError((_) {});
      ReminderService.instance.syncFrom(widget.profile);
      PublicProfileService.instance
          .save(
            uid: widget.user.uid,
            name: (widget.profile['name'] as String?) ??
                widget.user.displayName ??
                'Member',
            avatar: widget.profile['avatar'] as String?,
          )
          .catchError((_) {});
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  /// Tapping a tab (or a shortcut): slide over to it. Further tabs take a
  /// little longer so it never looks like a jump.
  void _goTo(int i) {
    if (i == _index) return;
    final distance = (i - _index).abs();
    setState(() => _index = i);
    if (!_pages.hasClients) return;
    if (MediaQuery.of(context).disableAnimations) {
      _pages.jumpToPage(i);
      return;
    }
    _pages.animateToPage(
      i,
      duration: Duration(milliseconds: 280 + 70 * (distance - 1)),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(user: widget.user, profile: widget.profile, onGoTo: _goTo),
      FeedScreen(user: widget.user, profile: widget.profile),
      ChatScreen(user: widget.user, profile: widget.profile),
      ProfileScreen(user: widget.user, profile: widget.profile),
    ];

    // Phone back button on another tab returns to Home first.
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goTo(0);
      },
      child: MilestoneWatcher(
        user: widget.user,
        profile: widget.profile,
        child: Scaffold(
          // Swipe left/right between tabs; every tab keeps its place.
          body: PageView(
            controller: _pages,
            onPageChanged: (i) => setState(() => _index = i),
            children: [
              for (var i = 0; i < pages.length; i++)
                _KeepAlive(
                  child: TickerMode(
                    enabled: i == _index,
                    child: ColoredBox(color: AppColors.bg, child: pages[i]),
                  ),
                ),
            ],
          ),
          bottomNavigationBar:
              BottomNav(index: _index, onTap: _goTo, pages: _pages),
        ),
      ),
    );
  }
}

/// Keeps a tab alive (scroll position, loaded data) when you swipe away.
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});
  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
