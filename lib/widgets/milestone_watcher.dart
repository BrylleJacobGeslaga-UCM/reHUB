import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/goals.dart';
import '../services/goal_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

/// Wraps the app and shows a small celebration the first time a milestone
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => _Celebration(title: milestone.title),
      );
      _showing = false;
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _Celebration extends StatelessWidget {
  const _Celebration({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const IconTile(icon: Icons.emoji_events_outlined, size: 72),
            const SizedBox(height: 16),
            Text('Milestone reached!',
                textAlign: TextAlign.center, style: AppText.heading),
            const SizedBox(height: 6),
            Text(title,
                textAlign: TextAlign.center,
                style: AppText.title.copyWith(color: AppColors.primary)),
            const SizedBox(height: 10),
            Text(
              'Every step counts. Be proud of showing up for yourself.',
              textAlign: TextAlign.center,
              style: AppText.body.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Keep going'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
