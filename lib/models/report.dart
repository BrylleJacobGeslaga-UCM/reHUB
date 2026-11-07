import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ReportReason { harassment, substances, selfHarm, spam, other }

extension ReportReasonText on ReportReason {
  String get label => switch (this) {
        ReportReason.harassment => 'Harassment or bullying',
        ReportReason.substances => 'Encouraging or selling substances',
        ReportReason.selfHarm => 'Someone may be at risk of self-harm',
        ReportReason.spam => 'Spam or scam',
        ReportReason.other => 'Something else',
      };

  IconData get icon => switch (this) {
        ReportReason.harassment => Icons.front_hand_outlined,
        ReportReason.substances => Icons.medication_outlined,
        ReportReason.selfHarm => Icons.support_outlined,
        ReportReason.spam => Icons.block_outlined,
        ReportReason.other => Icons.more_horiz_rounded,
      };
}

/// What kind of thing is being reported.
enum ReportType { post, comment, message }

extension ReportTypeText on ReportType {
  String get label => switch (this) {
        ReportType.post => 'Post',
        ReportType.comment => 'Comment',
        ReportType.message => 'Chat message',
      };
}

/// Everything needed to report a piece of content (and later remove it).
class ReportTarget {
  const ReportTarget({
    required this.type,
    required this.path,
    required this.hubId,
    required this.hubName,
    required this.preview,
    required this.authorName,
    this.postId,
  });

  final ReportType type;

  /// Firestore path of the content, e.g. "posts/abc" or
  /// "hubs/x/messages/y".
  final String path;
  final String hubId;
  final String hubName;
  final String preview;
  final String authorName;

  /// For comments: the post they belong to (to fix its comment count).
  final String? postId;

  String get contentId => path.split('/').last;
}

/// A report, stored at reports/{id}. Admins only.
class Report {
  const Report({
    required this.id,
    required this.type,
    required this.path,
    required this.hubId,
    required this.hubName,
    required this.preview,
    required this.authorName,
    required this.reason,
    required this.details,
    required this.createdAt,
    this.postId,
  });

  final String id;
  final ReportType type;
  final String path;
  final String hubId;
  final String hubName;
  final String preview;
  final String authorName;
  final ReportReason reason;
  final String details;
  final DateTime createdAt;
  final String? postId;

  factory Report.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return Report(
      id: doc.id,
      type: ReportType.values.firstWhere((t) => t.name == d['type'],
          orElse: () => ReportType.post),
      path: d['path'] as String? ?? '',
      hubId: d['hubId'] as String? ?? '',
      hubName: d['hubName'] as String? ?? '',
      preview: d['preview'] as String? ?? '',
      authorName: d['authorName'] as String? ?? 'Member',
      reason: ReportReason.values.firstWhere((r) => r.name == d['reason'],
          orElse: () => ReportReason.other),
      details: d['details'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      postId: d['postId'] as String?,
    );
  }
}
