import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/checkin.dart';

/// Private daily check-ins: users/{uid}/checkins/{yyyy-MM-dd}.
class CheckInService {
  CheckInService._();
  static final instance = CheckInService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('checkins');

  /// Today's check-in, or null if the user hasn't checked in yet.
  Stream<CheckIn?> today(String uid) => _col(uid)
      .doc(dateKey(DateTime.now()))
      .snapshots()
      .map((d) => d.exists ? CheckIn.fromDoc(d) : null);

  /// All check-ins, newest first.
  Stream<List<CheckIn>> history(String uid) => _col(uid)
      .orderBy('date', descending: true)
      .limit(400)
      .snapshots()
      .map((s) => s.docs.map(CheckIn.fromDoc).toList());

  /// Saves today's check-in. Checking in again the same day updates it.
  Future<void> saveToday(String uid, Mood mood, String note) {
    final key = dateKey(DateTime.now());
    return _col(uid).doc(key).set({
      'date': key,
      'mood': mood.name,
      'note': note.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Days in a row with a check-in, counting back from today
  /// (or from yesterday if today isn't done yet).
  static int streak(Iterable<CheckIn> all) {
    final keys = all.map((c) => c.key).toSet();
    var day = DateTime.now();
    if (!keys.contains(dateKey(day))) {
      day = day.subtract(const Duration(days: 1));
    }
    var count = 0;
    while (keys.contains(dateKey(day))) {
      count++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return count;
  }
}
