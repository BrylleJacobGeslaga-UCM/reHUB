import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum Mood { great, okay, struggling }

extension MoodStyle on Mood {
  String get label => switch (this) {
        Mood.great => 'Great',
        Mood.okay => 'Okay',
        Mood.struggling => 'Struggling',
      };

  IconData get icon => switch (this) {
        Mood.great => Icons.sentiment_very_satisfied_outlined,
        Mood.okay => Icons.sentiment_neutral_outlined,
        Mood.struggling => Icons.sentiment_dissatisfied_outlined,
      };

  /// Calendar / badge color. The three differ in lightness, not just hue.
  Color get color => switch (this) {
        Mood.great => AppColors.primary,
        Mood.okay => AppColors.leaf,
        Mood.struggling => AppColors.accent,
      };

  Color get onColor => this == Mood.great ? Colors.white : AppColors.text;
}

Mood moodFromName(String? name) =>
    Mood.values.firstWhere((m) => m.name == name, orElse: () => Mood.okay);

String _two(int n) => n.toString().padLeft(2, '0');

/// "2026-11-07" — used as the document id, so there's one check-in per day.
String dateKey(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';

const monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June', 'July',
  'August', 'September', 'October', 'November', 'December'
];
const weekdayNames = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];

/// "Saturday, November 7"
String longDate(DateTime d) =>
    '${weekdayNames[d.weekday - 1]}, ${monthNames[d.month - 1]} ${d.day}';

/// One daily check-in, stored at users/{uid}/checkins/{yyyy-MM-dd}.
class CheckIn {
  const CheckIn({required this.date, required this.mood, required this.note});

  final DateTime date;
  final Mood mood;
  final String note;

  String get key => dateKey(date);

  factory CheckIn.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    return CheckIn(
      date: DateTime.tryParse(d['date'] as String? ?? doc.id) ?? DateTime.now(),
      mood: moodFromName(d['mood'] as String?),
      note: d['note'] as String? ?? '',
    );
  }
}
