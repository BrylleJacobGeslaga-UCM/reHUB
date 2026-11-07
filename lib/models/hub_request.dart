import 'package:cloud_firestore/cloud_firestore.dart';

enum RequestStatus { pending, approved, rejected }

/// A member's suggestion for a new hub, stored at hubRequests/{id}.
/// Only the requester and admins can see it.
class HubRequest {
  const HubRequest({
    required this.id,
    required this.name,
    required this.interest,
    required this.online,
    required this.description,
    required this.requestedBy,
    required this.requesterName,
    required this.status,
    required this.createdAt,
    this.reviewNote,
    this.hubId,
  });

  final String id;
  final String name;
  final String interest;
  final bool online;
  final String description;
  final String requestedBy;
  final String requesterName;
  final RequestStatus status;
  final DateTime createdAt;
  final String? reviewNote;
  final String? hubId;

  factory HubRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return HubRequest(
      id: doc.id,
      name: d['name'] as String? ?? '',
      interest: d['interest'] as String? ?? '',
      online: d['online'] as bool? ?? false,
      description: d['description'] as String? ?? '',
      requestedBy: d['requestedBy'] as String? ?? '',
      requesterName: d['requesterName'] as String? ?? 'Member',
      status: RequestStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => RequestStatus.pending,
      ),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewNote: d['reviewNote'] as String?,
      hubId: d['hubId'] as String?,
    );
  }
}
