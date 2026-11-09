import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/goals.dart';
import '../../services/goal_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/screen_header.dart';
import '../checkin/checkin_screen.dart';
import '../hubs/discover_screen.dart';
import 'plan_screen.dart';

void openGoals(BuildContext context, User user, {ValueChanged<int>? onGoTo}) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => GoalsScreen(user: user, onGoTo: onGoTo),
  ));
}

/// Runs a goal's "next step" button.
void runGoalAction(
  BuildContext context, {
  required User user,
  required GoalAction action,
  required List<String> joined,
  ValueChanged<int>? onGoTo,
}) {
  switch (action) {
    case GoalAction.checkIn:
      openCheckIn(context, user);
    case GoalAction.plan:
      openPlan(context, user);
    case GoalAction.feed when onGoTo != null:
      Navigator.of(context).popUntil((r) => r.isFirst);
      onGoTo(1);
    case GoalAction.feed:
    case GoalAction.discover:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => DiscoverScreen(user: user, joined: joined),
      ));
  }
}

/// All goals with their milestones. Add or remove goals anytime.
class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key, required this.user, this.onGoTo});

  final User user;
  final ValueChanged<int>? onGoTo;

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late final _profile = UserService.instance.userDoc(widget.user.uid);
  late final _stats = GoalService.instance.stats(widget.user.uid);

  Future<void> _setGoals(List<String> goals, String message) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await GoalService.instance.setGoals(widget.user.uid, goals);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t update your goals.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _profile,
        builder: (context, profileSnap) {
          final profile = profileSnap.data?.data() ?? const {};
          final chosen = List<String>.from(profile['goals'] ?? const []);
          final joined = List<String>.from(profile['joinedHubs'] ?? const []);

          return StreamBuilder<GoalStats>(
            stream: _stats,
            builder: (context, statsSnap) {
              final stats = (statsSnap.data ?? const GoalStats())
                  .withJoinedHubs(joined.length);
              final mine =
                  chosen.map(goalById).whereType<GoalDef>().toList();
              final others =
                  goalDefs.where((g) => !chosen.contains(g.id)).toList();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ScreenHeader(
                      title: 'Your goals',
                      subtitle: 'Small steps add up. Progress never resets.',
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!statsSnap.hasData)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: AppColors.primary),
                              ),
                            ),
                          if (mine.isEmpty && statsSnap.hasData)
                            Text(
                              'You haven’t picked any goals yet. Add one below.',
                              style: AppText.body
                                  .copyWith(color: AppColors.textMuted),
                            ),
                          for (final g in mine)
                            if (statsSnap.hasData)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _GoalCard(
                                  goal: g,
                                  stats: stats,
                                  onAction: () => runGoalAction(
                                    context,
                                    user: widget.user,
                                    action: g.action(stats),
                                    joined: joined,
                                    onGoTo: widget.onGoTo,
                                  ),
                                  onRemove: () => _setGoals(
                                    chosen.where((id) => id != g.id).toList(),
                                    'Removed “${g.label}”. Your progress is kept.',
                                  ),
                                ),
                              ),
                          if (others.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text('More goals', style: AppText.title),
                            const SizedBox(height: 10),
                            for (final g in others)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppCard(
                                  onTap: () => _setGoals(
                                      [...chosen, g.id], 'Added “${g.label}”.'),
                                  child: Row(
                                    children: [
                                      IconTile(icon: g.icon, size: 44),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(g.label,
                                                style: AppText.bodyStrong),
                                            Text(g.description,
                                                style: AppText.caption.copyWith(
                                                    color:
                                                        AppColors.textMuted)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.add_circle_outline_rounded,
                                          color: AppColors.primary),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.stats,
    required this.onAction,
    required this.onRemove,
  });

  final GoalDef goal;
  final GoalStats stats;
  final VoidCallback onAction;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final done = goal.doneCount(stats);
    final total = goal.milestones.length;
    final complete = done == total;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(icon: goal.icon, size: 44),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.label, style: AppText.title),
                    Text(
                      complete
                          ? 'All milestones reached!'
                          : '$done of $total milestones',
                      style: AppText.caption.copyWith(
                          color: complete
                              ? AppColors.primary
                              : AppColors.textMuted,
                          fontWeight: complete ? FontWeight.w700 : null),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Goal options',
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppColors.textSubtle),
                onSelected: (_) => onRemove(),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'remove', child: Text('Remove goal')),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 10, 0),
            child: Text(goal.description,
                style: AppText.caption.copyWith(color: AppColors.textMuted)),
          ),
          if (goal.id == 'consistent')
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
              child: Text(
                'This week: ${stats.checkInsThisWeek} of 7 days',
                style: AppText.caption.copyWith(
                    color: AppColors.primaryStrong,
                    fontWeight: FontWeight.w700),
              ),
            ),
          const SizedBox(height: 12),
          for (final m in goal.milestones)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 10),
              child: Row(
                children: [
                  Icon(
                    m.done(stats)
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 22,
                    color: m.done(stats)
                        ? AppColors.primary
                        : AppColors.textSubtle,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      m.title,
                      style: AppText.body.copyWith(
                        color: m.done(stats)
                            ? AppColors.text
                            : AppColors.textMuted,
                        fontWeight:
                            m.done(stats) ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (m.target > 1 && !m.done(stats))
                    Text('${m.current(stats)} / ${m.target}',
                        style: AppText.caption
                            .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          if (!complete || goal.id == 'consistent' || goal.id == 'relapse')
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.arrow_forward_rounded,
                      size: 18, color: AppColors.primary),
                  label: Text(goal.actionLabel,
                      style: AppText.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
