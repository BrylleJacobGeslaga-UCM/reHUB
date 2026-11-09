import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Reaction { support, proud, relate }

extension ReactionStyle on Reaction {
  String get label => switch (this) {
        Reaction.support => 'Support',
        Reaction.proud => 'Proud',
        Reaction.relate => 'Relate',
      };

  IconData get icon => switch (this) {
        Reaction.support => Icons.favorite_border_rounded,
        Reaction.proud => Icons.star_border_rounded,
        Reaction.relate => Icons.people_outline_rounded,
      };

  IconData get selectedIcon => switch (this) {
        Reaction.support => Icons.favorite_rounded,
        Reaction.proud => Icons.star_rounded,
        Reaction.relate => Icons.people_rounded,
      };
}

Reaction? reactionFromName(String? name) {
  for (final r in Reaction.values) {
    if (r.name == name) return r;
  }
  return null;
}

int _count(Object? v) {
  final n = (v as num?)?.toInt() ?? 0;
  return n < 0 ? 0 : n;
}

String _initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  final first = parts.first.isNotEmpty ? parts.first[0] : '?';
  final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
  return (first + last).toUpperCase();
}

/// A feed post, stored at posts/{id}.
///
/// Posts deliberately do NOT store the author's user id, so anonymous
/// posts can't be traced back. Ownership lives privately at
/// users/{uid}/posts/{postId}.
class Post {
  const Post({
    required this.id,
    required this.hubId,
    required this.hubName,
    required this.authorName,
    required this.anonymous,
    required this.body,
    required this.createdAt,
    required this.counts,
    required this.commentCount,
    this.authorId,
  });

  final String id;
  final String hubId;
  final String hubName;
  final String? authorName;
  final bool anonymous;
  final String body;
  final DateTime createdAt;
  final Map<Reaction, int> counts;
  final int commentCount;

  /// Only set on named (non-anonymous) posts, so members can block authors.
  final String? authorId;

  String get displayName =>
      anonymous ? 'Anonymous member' : (authorName ?? 'Member');
  String get initials => _initialsOf(displayName);

  factory Post.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    final raw = (d['reactions'] as Map?) ?? const {};
    return Post(
      id: doc.id,
      hubId: d['hubId'] as String? ?? '',
      hubName: d['hubName'] as String? ?? '',
      authorName: d['authorName'] as String?,
      anonymous: d['anonymous'] as bool? ?? false,
      body: d['body'] as String? ?? '',
      // Brand-new posts have no server time yet for a split second.
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      counts: {for (final r in Reaction.values) r: _count(raw[r.name])},
      commentCount: _count(d['commentCount']),
      authorId: d['authorId'] as String?,
    );
  }
}

/// A reply on a post, stored at posts/{postId}/comments/{id}.
/// Like posts, anonymous comments store no author id.
class Comment {
  const Comment({
    required this.id,
    required this.authorName,
    required this.anonymous,
    required this.body,
    required this.createdAt,
    this.authorId,
  });

  final String id;

  /// Only set on named (non-anonymous) comments.
  final String? authorId;
  final String? authorName;
  final bool anonymous;
  final String body;
  final DateTime createdAt;

  String get displayName =>
      anonymous ? 'Anonymous member' : (authorName ?? 'Member');
  String get initials => _initialsOf(displayName);

  factory Comment.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return Comment(
      id: doc.id,
      authorName: d['authorName'] as String?,
      anonymous: d['anonymous'] as bool? ?? false,
      body: d['body'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      authorId: d['authorId'] as String?,
    );
  }
}

/// "just now", "5m ago", "3h ago", "2d ago", or a date.
String timeAgo(DateTime t) {
  final diff = DateTime.now().difference(t);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep',
    'Oct', 'Nov', 'Dec'];
  return '${m[t.month - 1]} ${t.day}';
}
