import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// A hub (community), stored in Firestore at hubs/{id}.
class Hub {
  const Hub({
    required this.id,
    required this.name,
    required this.interest,
    required this.iconKey,
    required this.online,
    required this.description,
    this.memberCount = 0,
    this.leaderName,
    this.leaderId,
    this.founderName,
  });

  final String id;
  final String name;

  /// Matches an interest id from onboarding (riding, gaming, ...).
  final String interest;

  /// Which icon to show; see [icon]. Stored as text because Firestore
  /// can't store Flutter icons.
  final String iconKey;
  final bool online;
  final String description;
  final int memberCount;

  /// The current hub leader (null when admins manage the hub).
  final String? leaderName;

  /// The hub leader's user id; they can add activities.
  final String? leaderId;

  /// Who originally suggested the hub. Kept even if they step down.
  final String? founderName;

  bool get hasLeader => leaderId != null && leaderName != null;

  String get modeLabel => online ? 'Online' : 'Outdoors';

  String get membersLabel =>
      memberCount == 1 ? '1 member' : '$memberCount members';

  IconData get icon => switch (iconKey) {
        'riding' => Icons.two_wheeler_rounded,
        'gaming' => Icons.sports_esports_outlined,
        'hiking' => Icons.hiking_rounded,
        'sports' => Icons.sports_soccer_outlined,
        'art' => Icons.palette_outlined,
        'cooking' => Icons.restaurant_outlined,
        'music' => Icons.music_note_outlined,
        'reading' => Icons.menu_book_outlined,
        _ => Icons.groups_outlined,
      };

  factory Hub.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return Hub(
      id: doc.id,
      name: d['name'] as String? ?? 'Hub',
      interest: d['interest'] as String? ?? '',
      iconKey: d['iconKey'] as String? ?? '',
      online: d['online'] as bool? ?? false,
      description: d['description'] as String? ?? '',
      memberCount: (d['memberCount'] as num?)?.toInt() ?? 0,
      leaderName: d['leaderName'] as String?,
      leaderId: d['leaderId'] as String?,
      founderName: d['founderName'] as String?,
    );
  }

  Map<String, dynamic> toSeed() => {
        'name': name,
        'interest': interest,
        'iconKey': iconKey,
        'online': online,
        'description': description,
        'memberCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };
}

/// Starter hubs, written to Firestore the first time the app runs.
const seedHubs = <Hub>[
  Hub(
    id: 'morning-riders',
    name: 'Morning Riders',
    interest: 'riding',
    iconKey: 'riding',
    online: false,
    description: 'Join us for peaceful morning rides through scenic routes. '
        'A supportive group focused on mindfulness and the open road. '
        'All experience levels welcome.',
  ),
  Hub(
    id: 'couch-gamers',
    name: 'Couch Gamers',
    interest: 'gaming',
    iconKey: 'gaming',
    online: true,
    description: 'Casual gaming sessions in a judgment-free space. Play '
        'together, support each other, and have fun. No competitive '
        'pressure, just good vibes.',
  ),
  Hub(
    id: 'trail-seekers',
    name: 'Trail Seekers',
    interest: 'hiking',
    iconKey: 'hiking',
    online: false,
    description: 'Explore nature trails and build connections. Every hike '
        'is a step forward on your journey. We focus on the experience, '
        'not the destination.',
  ),
  Hub(
    id: 'football-warriors',
    name: 'Football Warriors',
    interest: 'sports',
    iconKey: 'sports',
    online: false,
    description: 'Friendly weekend games for every skill level. Show up, '
        'play, and cheer each other on.',
  ),
  Hub(
    id: 'creative-circle',
    name: 'Creative Circle',
    interest: 'art',
    iconKey: 'art',
    online: true,
    description: 'Draw, paint, craft or doodle. Share what you made this '
        'week and get gentle, encouraging feedback.',
  ),
  Hub(
    id: 'kitchen-crew',
    name: 'Kitchen Crew',
    interest: 'cooking',
    iconKey: 'cooking',
    online: true,
    description: 'Simple, healthy recipes and cook-along nights. '
        'Good food is a great habit to build.',
  ),
  Hub(
    id: 'jam-session',
    name: 'Jam Session',
    interest: 'music',
    iconKey: 'music',
    online: true,
    description: 'Play, sing or just listen. Share the songs that keep '
        'you going.',
  ),
  Hub(
    id: 'book-nook',
    name: 'Book Nook',
    interest: 'reading',
    iconKey: 'reading',
    online: true,
    description: 'A slow, cozy reading club. One chapter at a time, '
        'no pressure to keep up.',
  ),
];
