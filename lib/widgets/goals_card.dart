import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/goals.dart';
import '../screens/goals/goals_screen.dart';
import '../services/goal_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

/// "Your goals" on Home: progress for each chosen goal and the next step.
class GoalsCard extends StatefulWidget {
  const GoalsCard({
    super.key,
    required this.user,
    required this.profile,
    required this.onGoTo,
  });

  final User user;
  final Map<String, dynamic> profile;
  final ValueChanged<int> onGoTo;

  @override
  State<GoalsCard> createState() => _GoalsCardState();
}

class _GoalsCardState extends State<GoalsCard> {
  late final _stats = GoalService.instance.stats(widget.user.uid);

  @override
  Widget build(BuildContext context) {
    final chosen = List<String>.from(widget.profile['goals'] ?? const []);
    final joined = List<String>.from(widget.profile['joinedHubs'] ?? const []);
    final goals = chosen.map(goalById).whereType<GoalDef>().toList();

    return StreamBuilder<GoalStats>(
      stream: _stats,
      builder: (context, snap) {
        final stats =
            (snap.data ?? const GoalStats()).withJoinedHubs(joined.length);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Your goals', style: AppText.title),
                TextButton(
                  onPressed: () =>
                      openGoals(context, widget.user, onGoTo: widget.onGoTo),
                  child: Text(goals.isEmpty ? 'Set a goal' : 'See all',
                      style: AppText.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            if (goals.isEmpty)
              AppCard(
                onTap: () =>
                    openGoals(context, widget.user, onGoTo: widget.onGoTo),
                child: Text(
                  'Pick a goal to get gentle milestones and next steps.',
                  style: AppText.caption.copyWith(color: AppColors.textMuted),
                ),
              )
            else
              AppCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                onTap: () =>
                    openGoals(context, widget.user, onGoTo: widget.onGoTo),
                child: Column(
                  children: [
                    for (final g in goals)
                      _GoalRow(goal: g, stats: stats, loading: !snap.hasData),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({
    required this.goal,
    required this.stats,
    required this.loading,
  });

  final GoalDef goal;
  final GoalStats stats;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final done = goal.doneCount(stats);
    final total = goal.milestones.length;
    final next = goal.next(stats);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconTile(icon: goal.icon, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(goal.label, style: AppText.bodyStrong)),
                    if (!loading)
                      Text('$done/$total',
                          style: AppText.caption.copyWith(
                              color: AppColors.primaryStrong,
                              fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: loading ? null : done / total,
                    minHeight: 6,
                    color: AppColors.primary,
                    backgroundColor: AppColors.primaryTint,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  loading
                      ? ' '
                      : next == null
                          ? 'All milestones reached!'
                          : next.target > 1
                              ? 'Next: ${next.title} (${next.current(stats)}/${next.target})'
                              : 'Next: ${next.title}',
                  style: AppText.caption.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
