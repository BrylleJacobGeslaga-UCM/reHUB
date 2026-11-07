import 'package:cloud_firestore/cloud_firestore.dart';

import 'checkin.dart' show monthNames, weekdayNames;
import 'message.dart' show clockTime;

/// A hub activity / meetup, stored at hubs/{hubId}/events/{id}.
/// Members only.
class HubEvent {
  const HubEvent({
    required this.id,
    required this.hubId,
    required this.title,
    required this.startsAt,
    required this.place,
    required this.details,
    required this.createdByName,
    required this.goingCount,
  });

  final String id;
  final String hubId;
  final String title;
  final DateTime startsAt;
  final String place;
  final String details;
  final String createdByName;
  final int goingCount;

  /// "NOV"
  String get monthShort =>
      monthNames[startsAt.month - 1].substring(0, 3).toUpperCase();

  /// "Sat, Nov 8 · 7:00 AM"
  String get whenLabel =>
      '${weekdayNames[startsAt.weekday - 1].substring(0, 3)}, '
      '${monthNames[startsAt.month - 1].substring(0, 3)} ${startsAt.day} · '
      '${clockTime(startsAt)}';

  factory HubEvent.fromDoc(String hubId, DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    final going = (d['goingCount'] as num?)?.toInt() ?? 0;
    return HubEvent(
      id: doc.id,
      hubId: hubId,
      title: d['title'] as String? ?? 'Activity',
      startsAt: (d['startsAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      place: d['place'] as String? ?? '',
      details: d['details'] as String? ?? '',
      createdByName: d['createdByName'] as String? ?? 'Hub leader',
      goingCount: going < 0 ? 0 : going,
    );
  }
}
