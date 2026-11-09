import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/goals.dart';
import '../screens/goals/goals_screen.dart';
import '../services/goal_service.dart';
import 'milestone_banner.dart';

/// Wraps the app and slides down a small celebration banner the first time a milestone
/// is reached. Reached milestones are saved to the profile
/// ("achievements") so each is celebrated only once.
class MilestoneWatcher extends StatefulWidget {
  const MilestoneWatcher({
    super.key,
    required this.user,
    required this.profile,
    required this.child,
  });

  final User user;
  final Map<String, dynamic> profile;
  final Widget child;

  @override
  State<MilestoneWatcher> createState() => _MilestoneWatcherState();
}

class _MilestoneWatcherState extends State<MilestoneWatcher> {
  StreamSubscription<GoalStats>? _sub;
  GoalStats? _stats;
  final _handled = <String>{};
  bool _showing = false;

  @override
  void initState() {
    super.initState();
    if (!widget.user.isAnonymous) {
      _sub = GoalService.instance.stats(widget.user.uid).listen((s) {
        _stats = s;
        _check();
      });
    }
  }

  @override
  void didUpdateWidget(MilestoneWatcher old) {
    super.didUpdateWidget(old);
    _check(); // goals or joined hubs may have changed
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _check() {
    final stats = _stats;
    if (stats == null || _showing) return;
    final profile = widget.profile;
    final goals = List<String>.from(profile['goals'] ?? const []);
    final joined = List<String>.from(profile['joinedHubs'] ?? const []);
    final reached =
        reachedMilestones(goals, stats.withJoinedHubs(joined.length));

    final saved = profile['achievements'];
    if (saved == null) {
      // First time: record existing progress quietly, no pop-ups.
      if (reached.isNotEmpty) {
        _handled.addAll(reached);
        GoalService.instance
            .addAchievements(widget.user.uid, reached)
            .catchError((_) {});
      } else {
        GoalService.instance
            .addAchievements(widget.user.uid, const [])
            .catchError((_) {});
      }
      return;
    }

    final known = {...List<String>.from(saved as List), ..._handled};
    final fresh = reached.difference(known);
    if (fresh.isEmpty) return;

    _handled.addAll(fresh);
    GoalService.instance
        .addAchievements(widget.user.uid, fresh)
        .catchError((_) {});

    final milestone = milestoneById(fresh.first);
    if (milestone == null) return;
    _showing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _showing = false;
        return;
      }
      showMilestoneBanner(
        context,
        title: milestone.title,
        onTap: () {
          if (mounted) openGoals(context, widget.user);
        },
        onDone: () => _showing = false,
      );
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
