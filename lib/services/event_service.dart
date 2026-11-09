import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hub_event.dart';

/// Hub activities and RSVPs (members only).
///
///   hubs/{hubId}/events/{eventId}               the activity
///   hubs/{hubId}/events/{eventId}/going/{uid}   your RSVP
class EventService {
  EventService._();
  static final instance = EventService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _events(String hubId) =>
      _db.collection('hubs').doc(hubId).collection('events');

  /// Activities that haven't started more than 2 hours ago, soonest first.
  Stream<List<HubEvent>> upcoming(String hubId) {
    final since = DateTime.now().subtract(const Duration(hours: 2));
    return _events(hubId)
        .where('startsAt', isGreaterThanOrEqualTo: Timestamp.fromDate(since))
        .orderBy('startsAt')
        .limit(20)
        .snapshots()
        .map((s) => s.docs.map((d) => HubEvent.fromDoc(hubId, d)).toList());
  }

  Stream<bool> isGoing(String uid, String hubId, String eventId) => _events(hubId)
      .doc(eventId)
      .collection('going')
      .doc(uid)
      .snapshots()
      .map((d) => d.exists);

  Future<void> create({
    required String hubId,
    required String uid,
    required String createdByName,
    required String title,
    required DateTime startsAt,
    required String place,
    required String details,
  }) {
    return _events(hubId).add({
      'title': title.trim(),
      'startsAt': Timestamp.fromDate(startsAt),
      'place': place.trim(),
      'details': details.trim(),
      'createdBy': uid,
      'createdByName': createdByName,
      'goingCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String hubId, String eventId) =>
      _events(hubId).doc(eventId).delete();

  /// Tap once to RSVP, again to cancel. Counted safely in a transaction.
  Future<void> toggleGoing({
    required String uid,
    required String name,
    required String hubId,
    required String eventId,
  }) {
    final eventRef = _events(hubId).doc(eventId);
    final goingRef = eventRef.collection('going').doc(uid);
    // Private copy under the user, used for goal milestones.
    final myRef =
        _db.collection('users').doc(uid).collection('rsvps').doc(eventId);
    return _db.runTransaction((tx) async {
      final going = await tx.get(goingRef);
      if (going.exists) {
        tx.delete(goingRef);
        tx.delete(myRef);
        tx.update(eventRef, {'goingCount': FieldValue.increment(-1)});
      } else {
        tx.set(goingRef, {'name': name, 'at': FieldValue.serverTimestamp()});
        tx.set(myRef, {'hubId': hubId, 'at': FieldValue.serverTimestamp()});
        tx.update(eventRef, {'goingCount': FieldValue.increment(1)});
      }
    });
  }
}
