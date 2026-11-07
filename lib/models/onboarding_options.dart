import 'package:flutter/material.dart';

/// One selectable choice (an interest or a goal).
class Option {
  const Option({
    required this.id,
    required this.label,
    required this.icon,
    this.description,
  });

  final String id;
  final String label;
  final IconData icon;
  final String? description;
}

const interestOptions = <Option>[
  Option(id: 'riding', label: 'Riding', icon: Icons.two_wheeler_rounded),
  Option(id: 'gaming', label: 'Gaming', icon: Icons.sports_esports_outlined),
  Option(id: 'sports', label: 'Sports', icon: Icons.sports_soccer_outlined),
  Option(id: 'hiking', label: 'Hiking', icon: Icons.hiking_rounded),
  Option(id: 'art', label: 'Art', icon: Icons.palette_outlined),
  Option(id: 'cooking', label: 'Cooking', icon: Icons.restaurant_outlined),
  Option(id: 'music', label: 'Music', icon: Icons.music_note_outlined),
  Option(id: 'reading', label: 'Reading', icon: Icons.menu_book_outlined),
];

const goalOptions = <Option>[
  Option(
    id: 'consistent',
    label: 'Stay consistent',
    description: 'Build steady daily routines',
    icon: Icons.trending_up_rounded,
  ),
  Option(
    id: 'relapse',
    label: 'Avoid relapse',
    description: 'Stay on track with your recovery goals',
    icon: Icons.shield_outlined,
  ),
  Option(
    id: 'support',
    label: 'Find support',
    description: 'Connect with people who understand',
    icon: Icons.favorite_border_rounded,
  ),
  Option(
    id: 'community',
    label: 'Build community',
    description: 'Meet others through shared activities',
    icon: Icons.groups_outlined,
  ),
];

/// Looks up a label by id, e.g. labelFor(interestOptions, 'riding') → 'Riding'.
String labelFor(List<Option> options, String id) {
  for (final o in options) {
    if (o.id == id) return o.label;
  }
  return id;
}
