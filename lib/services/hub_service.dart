import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/hub.dart';

/// Reads hubs and handles joining/leaving.
///
/// Data layout:
///   hubs/{hubId}                 name, description, memberCount, ...
///   hubs/{hubId}/members/{uid}   name, joinedAt
///   users/{uid}.joinedHubs       [hubId, ...]  (quick list for the user)
class HubService {
  HubService._();
  static final instance = HubService._();

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _hubs =>
      _db.collection('hubs');

  Stream<List<Hub>> hubs() => _hubs
      .orderBy('name')
      .snapshots()
      .map((s) => s.docs.map(Hub.fromDoc).toList());

  Stream<Hub?> hub(String id) => _hubs
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? Hub.fromDoc(d) : null);

  /// Writes the starter hubs if the collection is empty.
  Future<void> ensureSeeded() async {
    final existing = await _hubs.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = _db.batch();
    for (final h in seedHubs) {
      batch.set(_hubs.doc(h.id), h.toSeed());
    }
    await batch.commit();
  }

  /// Joins a hub. Uses a transaction so the member count can't be
  /// counted twice if the button is tapped twice.
  Future<void> join({
    required User user,
    required String displayName,
    required String hubId,
  }) {
    final hubRef = _hubs.doc(hubId);
    final memberRef = hubRef.collection('members').doc(user.uid);
    final userRef = _db.collection('users').doc(user.uid);

    return _db.runTransaction((tx) async {
      final member = await tx.get(memberRef);
      if (member.exists) return;
      tx.set(memberRef, {
        'name': displayName,
        'joinedAt': FieldValue.serverTimestamp(),
      });
      tx.update(hubRef, {'memberCount': FieldValue.increment(1)});
      tx.set(
        userRef,
        {'joinedHubs': FieldValue.arrayUnion([hubId])},
        SetOptions(merge: true),
      );
    });
  }

  Future<void> leave({required User user, required String hubId}) {
    final hubRef = _hubs.doc(hubId);
    final memberRef = hubRef.collection('members').doc(user.uid);
    final userRef = _db.collection('users').doc(user.uid);

    return _db.runTransaction((tx) async {
      final member = await tx.get(memberRef);
      if (!member.exists) return;
      tx.delete(memberRef);
      tx.update(hubRef, {'memberCount': FieldValue.increment(-1)});
      tx.set(
        userRef,
        {'joinedHubs': FieldValue.arrayRemove([hubId])},
        SetOptions(merge: true),
      );
    });
  }
}
