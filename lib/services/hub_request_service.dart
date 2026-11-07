import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hub_request.dart';

/// Hub suggestions and admin review.
///
///   hubRequests/{id}   a suggestion (requester + admins can read it)
///   admins/{uid}       exists = that user is an admin (set in the console)
class HubRequestService {
  HubRequestService._();
  static final instance = HubRequestService._();

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _requests =>
      _db.collection('hubRequests');

  /// True if an admins/{uid} document exists for this user.
  Stream<bool> isAdmin(String uid) => _db
      .collection('admins')
      .doc(uid)
      .snapshots()
      .map((d) => d.exists)
      .handleError((_) => false);

  Stream<List<HubRequest>> myRequests(String uid) => _requests
      .where('requestedBy', isEqualTo: uid)
      .snapshots()
      .map((s) => s.docs.map(HubRequest.fromDoc).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  /// For admins: requests waiting for review, oldest first.
  Stream<List<HubRequest>> pending() => _requests
      .where('status', isEqualTo: RequestStatus.pending.name)
      .snapshots()
      .map((s) => s.docs.map(HubRequest.fromDoc).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)));

  Future<void> submit({
    required String uid,
    required String requesterName,
    required String name,
    required String interest,
    required bool online,
    required String description,
  }) {
    return _requests.add({
      'name': name.trim(),
      'interest': interest,
      'online': online,
      'description': description.trim(),
      'requestedBy': uid,
      'requesterName': requesterName,
      'status': RequestStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> cancel(String requestId) => _requests.doc(requestId).delete();

  /// Creates the real hub, makes the suggester its first member (they're
  /// the hub leader), and marks the request approved, all in one batch.
  Future<void> approve(HubRequest r) {
    final slug = r.name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final hubRef = _db
        .collection('hubs')
        .doc('${slug.isEmpty ? 'hub' : slug}-${r.id.substring(0, 5).toLowerCase()}');

    final batch = _db.batch();
    batch.set(hubRef, {
      'name': r.name,
      'interest': r.interest,
      'iconKey': r.interest,
      'online': r.online,
      'description': r.description,
      'memberCount': 1,
      'leaderId': r.requestedBy,
      'leaderName': r.requesterName,
      'founderName': r.requesterName,
      'requestId': r.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
    // The leader joins their own hub automatically.
    batch.set(hubRef.collection('members').doc(r.requestedBy), {
      'name': r.requesterName,
      'joinedAt': FieldValue.serverTimestamp(),
      'role': 'leader',
    });
    batch.update(_db.collection('users').doc(r.requestedBy), {
      'joinedHubs': FieldValue.arrayUnion([hubRef.id]),
    });
    batch.update(_requests.doc(r.id), {
      'status': RequestStatus.approved.name,
      'hubId': hubRef.id,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
    return batch.commit();
  }

  Future<void> decline(HubRequest r, {String? note}) {
    return _requests.doc(r.id).update({
      'status': RequestStatus.rejected.name,
      if (note != null && note.trim().isNotEmpty) 'reviewNote': note.trim(),
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }
}
