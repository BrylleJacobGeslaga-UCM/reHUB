import 'package:flutter/material.dart';

/// Everything goal progress is calculated from.
class GoalStats {
  const GoalStats({
    this.checkIns = 0,
    this.checkInsThisWeek = 0,
    this.posts = 0,
    this.comments = 0,
    this.reactions = 0,
    this.rsvps = 0,
    this.planReasons = false,
    this.planSigns = false,
    this.planHelps = false,
    this.joinedHubs = 0,
  });

  final int checkIns;
  final int checkInsThisWeek;
  final int posts;
  final int comments;
  final int reactions;
  final int rsvps;
  final bool planReasons;
  final bool planSigns;
  final bool planHelps;
  final int joinedHubs;

  GoalStats withJoinedHubs(int n) => GoalStats(
        checkIns: checkIns,
        checkInsThisWeek: checkInsThisWeek,
        posts: posts,
        comments: comments,
        reactions: reactions,
        rsvps: rsvps,
        planReasons: planReasons,
        planSigns: planSigns,
        planHelps: planHelps,
        joinedHubs: n,
      );
}

/// One step inside a goal. Counting milestones show "4 / 7".
class Milestone {
  const Milestone({
    required this.id,
    required this.title,
    required this.value,
    this.target = 1,
  });

  final String id;
  final String title;
  final int Function(GoalStats s) value;
  final int target;

  int current(GoalStats s) {
    final v = value(s);
    return v > target ? target : v;
  }

  bool done(GoalStats s) => value(s) >= target;
}

/// Where a goal's "next step" button takes you.
enum GoalAction { checkIn, plan, discover, feed }

class GoalDef {
  const GoalDef({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.milestones,
    required this.actionLabel,
    required this.action,
  });

  final String id;
  final String label;
  final String description;
  final IconData icon;
  final List<Milestone> milestones;
  final String actionLabel;
  final GoalAction Function(GoalStats s) action;

  int doneCount(GoalStats s) => milestones.where((m) => m.done(s)).length;
  bool complete(GoalStats s) => doneCount(s) == milestones.length;
  Milestone? next(GoalStats s) {
    for (final m in milestones) {
      if (!m.done(s)) return m;
    }
    return null;
  }
}

int _b(bool v) => v ? 1 : 0;

/// The four goals from onboarding. Ids match what onboarding saves.
final goalDefs = <GoalDef>[
  GoalDef(
    id: 'consistent',
    label: 'Stay consistent',
    description: 'Show up for yourself with a daily check-in. '
        'Missed days never take progress away.',
    icon: Icons.trending_up_rounded,
    actionLabel: 'Check in',
    action: (_) => GoalAction.checkIn,
    milestones: [
      Milestone(id: 'consistent_1', title: 'Your first check-in',
          value: (s) => s.checkIns),
      Milestone(id: 'consistent_7', title: 'Check in 7 times',
          value: (s) => s.checkIns, target: 7),
      Milestone(id: 'consistent_30', title: 'Check in 30 times',
          value: (s) => s.checkIns, target: 30),
    ],
  ),
  GoalDef(
    id: 'relapse',
    label: 'Avoid relapse',
    description: 'Build a private plan for hard moments, in your own words. '
        'It’s there whenever you need it.',
    icon: Icons.shield_outlined,
    actionLabel: 'Open my plan',
    action: (_) => GoalAction.plan,
    milestones: [
      Milestone(id: 'relapse_reasons', title: 'Write down your reasons',
          value: (s) => _b(s.planReasons)),
      Milestone(id: 'relapse_signs', title: 'Name your warning signs',
          value: (s) => _b(s.planSigns)),
      Milestone(id: 'relapse_helps', title: 'List what helps you',
          value: (s) => _b(s.planHelps)),
    ],
  ),
  GoalDef(
    id: 'support',
    label: 'Find support',
    description: 'Reach out to people who understand. '
        'Sharing gets easier with practice.',
    icon: Icons.favorite_border_rounded,
    actionLabel: 'Go to your hubs',
    action: (s) => s.joinedHubs == 0 ? GoalAction.discover : GoalAction.feed,
    milestones: [
      Milestone(id: 'support_join', title: 'Join a hub',
          value: (s) => s.joinedHubs),
      Milestone(id: 'support_share', title: 'Share your first update',
          value: (s) => s.posts),
      Milestone(id: 'support_reply', title: 'Reply to 3 posts',
          value: (s) => s.comments, target: 3),
    ],
  ),
  GoalDef(
    id: 'community',
    label: 'Build community',
    description: 'Show up for others: cheer people on and join activities.',
    icon: Icons.groups_outlined,
    actionLabel: 'Explore hubs',
    action: (_) => GoalAction.discover,
    milestones: [
      Milestone(id: 'community_cheer', title: 'Cheer on 5 posts',
          value: (s) => s.reactions, target: 5),
      Milestone(id: 'community_rsvp', title: 'RSVP to an activity',
          value: (s) => s.rsvps),
      Milestone(id: 'community_hubs', title: 'Join 3 hubs',
          value: (s) => s.joinedHubs, target: 3),
    ],
  ),
];

GoalDef? goalById(String id) {
  for (final g in goalDefs) {
    if (g.id == id) return g;
  }
  return null;
}

/// Milestone ids reached for the given goals.
Set<String> reachedMilestones(List<String> goalIds, GoalStats s) => {
      for (final g in goalIds.map(goalById).whereType<GoalDef>())
        for (final m in g.milestones)
          if (m.done(s)) m.id,
    };

Milestone? milestoneById(String id) {
  for (final g in goalDefs) {
    for (final m in g.milestones) {
      if (m.id == id) return m;
    }
  }
  return null;
}
