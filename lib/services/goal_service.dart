import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/checkin.dart';
import '../models/goals.dart';
import '../models/plan.dart';
import 'checkin_service.dart';
import 'post_service.dart';

/// Goal progress, the private recovery plan, and saved goals/achievements.
class GoalService {
  GoalService._();
  static final instance = GoalService._();

  final _db = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      _db.collection('users').doc(uid);
  DocumentReference<Map<String, dynamic>> _planRef(String uid) =>
      _user(uid).collection('private').doc('plan');

  // ---------- plan ----------

  Stream<RecoveryPlan> plan(String uid) => _planRef(uid)
      .snapshots()
      .map((d) => d.exists ? RecoveryPlan.fromDoc(d) : const RecoveryPlan());

  Future<void> savePlan(String uid, RecoveryPlan plan) =>
      _planRef(uid).set(plan.toMap());

  // ---------- goals ----------

  Future<void> setGoals(String uid, List<String> goals) =>
      _user(uid).set({'goals': goals}, SetOptions(merge: true));

  Future<void> addAchievements(String uid, Iterable<String> ids) =>
      _user(uid).set({
        'achievements': FieldValue.arrayUnion(ids.toList()),
      }, SetOptions(merge: true));

  // ---------- progress ----------

  Stream<int> _rsvps(String uid) =>
      _user(uid).collection('rsvps').snapshots().map((s) => s.size);

  /// Live progress numbers (everything except joined hubs, which comes
  /// from the profile). Emits once every source has loaded.
  Stream<GoalStats> stats(String uid) {
    final sources = <Stream<Object?>>[
      CheckInService.instance.history(uid),
      PostService.instance.myPostIds(uid),
      PostService.instance.myCommentIds(uid),
      PostService.instance.myReactions(uid),
      _rsvps(uid),
      plan(uid),
    ];
    final latest = List<Object?>.filled(sources.length, null);
    final loaded = List<bool>.filled(sources.length, false);
    final subs = <StreamSubscription<Object?>>[];
    late final StreamController<GoalStats> controller;

    void update(int i, Object? value) {
      latest[i] = value;
      loaded[i] = true;
      if (!loaded.contains(false)) controller.add(_build(latest));
    }

    controller = StreamController<GoalStats>(
      onListen: () {
        for (var i = 0; i < sources.length; i++) {
          subs.add(sources[i].listen(
            (v) => update(i, v),
            onError: (Object _) => update(i, null),
          ));
        }
      },
      onCancel: () async {
        for (final s in subs) {
          await s.cancel();
        }
      },
    );
    return controller.stream;
  }

  GoalStats _build(List<Object?> v) {
    final history = (v[0] as List<CheckIn>?) ?? const <CheckIn>[];
    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final plan = (v[5] as RecoveryPlan?) ?? const RecoveryPlan();
    return GoalStats(
      checkIns: history.length,
      checkInsThisWeek:
          history.where((c) => !c.date.isBefore(weekStart)).length,
      posts: (v[1] as Set?)?.length ?? 0,
      comments: (v[2] as Set?)?.length ?? 0,
      reactions: (v[3] as Map?)?.length ?? 0,
      rsvps: (v[4] as int?) ?? 0,
      planReasons: plan.reasons.isNotEmpty,
      planSigns: plan.signs.isNotEmpty,
      planHelps: plan.helps.isNotEmpty,
    );
  }
}
