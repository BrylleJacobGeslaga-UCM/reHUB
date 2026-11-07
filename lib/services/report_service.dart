import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report.dart';

class AlreadyReported implements Exception {}

/// Reports and moderation. reports/{id} is admin-only.
class ReportService {
  ReportService._();
  static final instance = ReportService._();

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _reports =>
      _db.collection('reports');

  /// One report per person per piece of content: the id includes both,
  /// and the rules only allow creating (never overwriting) it.
  Future<void> submit({
    required String uid,
    required ReportTarget target,
    required ReportReason reason,
    required String details,
  }) async {
    final id = '${target.type.name}_${target.contentId}_$uid';
    final preview = target.preview.length > 500
        ? '${target.preview.substring(0, 497)}...'
        : target.preview;
    try {
      await _reports.doc(id).set({
        'type': target.type.name,
        'path': target.path,
        'hubId': target.hubId,
        'hubName': target.hubName,
        if (target.postId != null) 'postId': target.postId,
        'preview': preview,
        'authorName': target.authorName,
        'reason': reason.name,
        'details': details.trim(),
        'reportedBy': uid,
        'status': 'open',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // Creating an id that already exists counts as an update → denied.
      if (e.code == 'permission-denied') throw AlreadyReported();
      rethrow;
    }
  }

  /// Admins: open reports, oldest first.
  Stream<List<Report>> open() => _reports
      .where('status', isEqualTo: 'open')
      .snapshots()
      .map((s) => s.docs.map(Report.fromDoc).toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt)));

  /// Admins: delete the reported content and close the report.
  Future<void> removeContent(Report r) async {
    final target = _db.doc(r.path);
    final exists = (await target.get()).exists;
    final batch = _db.batch();
    if (exists) {
      batch.delete(target);
      if (r.type == ReportType.comment && r.postId != null) {
        batch.update(_db.collection('posts').doc(r.postId),
            {'commentCount': FieldValue.increment(-1)});
      }
    }
    batch.update(_reports.doc(r.id), {
      'status': 'removed',
      'reviewedAt': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  Future<void> dismiss(Report r) => _reports.doc(r.id).update({
        'status': 'dismissed',
        'reviewedAt': FieldValue.serverTimestamp(),
      });
}
