import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A profile avatar: an icon on a colored circle, saved as one short
/// string like "eco.mint" (on the profile, and on named posts, comments and
/// chat messages so others see it).
class AvatarStyle {
  const AvatarStyle(this.iconId, this.colorId);

  final String iconId;
  final String colorId;

  IconData get icon => avatarIcons[iconId] ?? Icons.eco_rounded;
  AvatarColor get color => avatarColors[colorId] ?? avatarColors['mint']!;

  /// "eco.mint"
  String get code => '$iconId.$colorId';

  /// Reads a saved code; null if missing or not one we know.
  static AvatarStyle? parse(Object? code) {
    if (code is! String) return null;
    final parts = code.split('.');
    if (parts.length != 2) return null;
    if (!avatarIcons.containsKey(parts[0])) return null;
    if (!avatarColors.containsKey(parts[1])) return null;
    return AvatarStyle(parts[0], parts[1]);
  }

  /// The avatar saved on a profile, if any.
  static AvatarStyle? of(Map<String, dynamic> profile) =>
      parse(profile['avatar']);
}

class AvatarColor {
  const AvatarColor(this.background, this.foreground);
  final Color background;
  final Color foreground;
}

const avatarIcons = <String, IconData>{
  'eco': Icons.eco_rounded,
  'sun': Icons.wb_sunny_rounded,
  'book': Icons.menu_book_rounded,
  'wave': Icons.waves_rounded,
  'game': Icons.sports_esports_rounded,
  'music': Icons.music_note_rounded,
  'bike': Icons.pedal_bike_rounded,
  'hike': Icons.landscape_rounded,
  'art': Icons.palette_rounded,
  'coffee': Icons.local_cafe_rounded,
  'paw': Icons.pets_rounded,
  'star': Icons.star_rounded,
  'heart': Icons.favorite_rounded,
  'rocket': Icons.rocket_launch_rounded,
  'camera': Icons.photo_camera_rounded,
  'ball': Icons.sports_basketball_rounded,
};

const avatarColors = <String, AvatarColor>{
  'mint': AvatarColor(AppColors.primaryTint, AppColors.primary),
  'forest': AvatarColor(AppColors.primary, Colors.white),
  'peach': AvatarColor(AppColors.accentTint, Color(0xFFB8641E)),
  'sky': AvatarColor(Color(0xFFE2EDFA), Color(0xFF2F6FB3)),
  'lavender': AvatarColor(Color(0xFFEDE7FA), Color(0xFF6A4FB3)),
  'rose': AvatarColor(Color(0xFFFBE5EC), Color(0xFFB23A5E)),
  'sand': AvatarColor(Color(0xFFF5EDD9), Color(0xFF8A6A1F)),
  'slate': AvatarColor(Color(0xFFE5E9EC), Color(0xFF44525C)),
};

/// Longest name allowed (sign up and edit profile).
const maxNameLength = 30;
