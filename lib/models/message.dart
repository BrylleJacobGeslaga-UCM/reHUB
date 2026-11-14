import 'package:cloud_firestore/cloud_firestore.dart';

import 'avatar.dart';

/// A chat message, stored at hubs/{hubId}/messages/{id}.
class Message {
  const Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.body,
    required this.createdAt,
    this.pending = false,
    this.senderAvatar,
  });

  final String id;
  final String senderId;
  final String senderName;
  final String body;
  final DateTime createdAt;

  /// True while the message is still being sent.
  final bool pending;

  final AvatarStyle? senderAvatar;

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return Message(
      id: doc.id,
      senderId: d['senderId'] as String? ?? '',
      senderName: d['senderName'] as String? ?? 'Member',
      body: d['body'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pending: doc.metadata.hasPendingWrites,
      senderAvatar: AvatarStyle.parse(d['senderAvatar']),
    );
  }
}

String _two(int n) => n.toString().padLeft(2, '0');

/// "2:05 PM"
String clockTime(DateTime t) {
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  return '$h:${_two(t.minute)} ${t.hour < 12 ? 'AM' : 'PM'}';
}

bool sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'];

/// "Today", "Yesterday", or "Nov 5".
String dayLabel(DateTime t) {
  final now = DateTime.now();
  if (sameDay(t, now)) return 'Today';
  if (sameDay(t, now.subtract(const Duration(days: 1)))) return 'Yesterday';
  return '${_months[t.month - 1]} ${t.day}';
}

/// For the chat list: "2:05 PM" today, otherwise "Yesterday" / "Nov 5".
String shortStamp(DateTime t) =>
    sameDay(t, DateTime.now()) ? clockTime(t) : dayLabel(t);
