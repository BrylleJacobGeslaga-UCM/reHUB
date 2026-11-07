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
      final hub = await tx.get(hubRef);
      final data = hub.data() ?? const {};
      tx.delete(memberRef);

      final updates = <String, dynamic>{
        'memberCount': FieldValue.increment(-1),
      };
      // The leader leaving gives up leadership; admins take over until
      // they assign someone new. Remember who started the hub.
      if (data['leaderId'] == user.uid) {
        updates['leaderId'] = FieldValue.delete();
        updates['leaderName'] = FieldValue.delete();
        updates['founderName'] = data['founderName'] ?? data['leaderName'];
      }
      tx.update(hubRef, updates);
      tx.set(
        userRef,
        {'joinedHubs': FieldValue.arrayRemove([hubId])},
        SetOptions(merge: true),
      );
    });
  }

  /// Admins: the hub's members (to pick a new leader).
  Stream<List<({String uid, String name})>> members(String hubId) => _hubs
      .doc(hubId)
      .collection('members')
      .snapshots()
      .map((s) => s.docs
          .map((d) => (uid: d.id, name: d.data()['name'] as String? ?? 'Member'))
          .toList()
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));

  /// Admins: make a member the leader, or pass null to remove the leader.
  Future<void> setLeader(String hubId, {String? uid, String? name}) {
    final hubRef = _hubs.doc(hubId);
    if (uid == null) {
      return hubRef.update({
        'leaderId': FieldValue.delete(),
        'leaderName': FieldValue.delete(),
      });
    }
    return hubRef.update({'leaderId': uid, 'leaderName': name ?? 'Member'});
  }

  /// Admins: permanently delete a (non-starter) hub and everything in it:
  /// posts and their comments, chat messages, activities, and memberships
  /// (also removing it from each member's joined list).
  Future<void> deleteHub(String hubId) async {
    final hubRef = _hubs.doc(hubId);

    final members = await hubRef.collection('members').get();
    final toDelete = <DocumentReference<Map<String, dynamic>>>[
      ...members.docs.map((d) => d.reference),
      ...(await hubRef.collection('events').get()).docs.map((d) => d.reference),
      ...(await hubRef.collection('messages').get())
          .docs
          .map((d) => d.reference),
    ];
    final posts =
        await _db.collection('posts').where('hubId', isEqualTo: hubId).get();
    for (final p in posts.docs) {
      final comments = await p.reference.collection('comments').get();
      toDelete.addAll(comments.docs.map((d) => d.reference));
      toDelete.add(p.reference);
    }

    // Firestore batches hold up to 500 writes, so commit in chunks.
    var batch = _db.batch();
    var count = 0;
    Future<void> add(void Function(WriteBatch b) write) async {
      write(batch);
      if (++count >= 400) {
        await batch.commit();
        batch = _db.batch();
        count = 0;
      }
    }

    for (final m in members.docs) {
      await add((b) => b.update(_db.collection('users').doc(m.id), {
            'joinedHubs': FieldValue.arrayRemove([hubId]),
          }));
    }
    for (final ref in toDelete) {
      await add((b) => b.delete(ref));
    }
    if (count > 0) await batch.commit();

    await hubRef.delete();
  }
}
