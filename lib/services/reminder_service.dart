import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// The daily check-in reminder. It's a local notification scheduled on the
/// phone itself: no server, nothing sent anywhere, works offline.
///
/// The on/off setting and time are saved on the profile
/// (reminderOn, reminderHour, reminderMinute) so they survive reinstalls.
class ReminderService {
  ReminderService._();
  static final instance = ReminderService._();

  static const _id = 1001;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Local notifications only exist in the phone app, not the web version.
  bool get supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> _init() async {
    if (_ready || !supported) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
    ));
    _ready = true;
  }

  /// Asks for notification permission (Android 13+). Returns true if allowed.
  Future<bool> requestPermission() async {
    if (!supported) return false;
    await _init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? true;
  }

  /// Schedules the reminder every day at [time]. If [skipToday] is true
  /// (you already checked in), the first one is tomorrow.
  Future<void> schedule(TimeOfDay time, {bool skipToday = false}) async {
    if (!supported) return;
    await _init();
    await _plugin.cancel(_id);

    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (skipToday || !next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      _id,
      'How are you feeling today?',
      'Take a minute for your daily check-in.',
      tz.TZDateTime.from(next, tz.UTC),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_checkin',
          'Daily check-in reminder',
          channelDescription: 'A gentle daily reminder to check in',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          color: Color(0xFF1F6B4C),
        ),
      ),
      // Inexact is fine for a reminder and needs no special permission.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancel() async {
    if (!supported) return;
    await _init();
    await _plugin.cancel(_id);
  }

  // ---------- saved setting ----------

  static TimeOfDay timeFrom(Map<String, dynamic> profile) => TimeOfDay(
        hour: (profile['reminderHour'] as num?)?.toInt() ?? 20,
        minute: (profile['reminderMinute'] as num?)?.toInt() ?? 0,
      );

  static bool isOn(Map<String, dynamic> profile) =>
      profile['reminderOn'] == true;

  Future<void> save(String uid, {required bool on, required TimeOfDay time}) =>
      FirebaseFirestore.instance.collection('users').doc(uid).set({
        'reminderOn': on,
        'reminderHour': time.hour,
        'reminderMinute': time.minute,
      }, SetOptions(merge: true));

  /// On app start: make the phone's schedule match the saved setting.
  Future<void> syncFrom(Map<String, dynamic> profile) async {
    if (!supported) return;
    try {
      if (isOn(profile)) {
        await schedule(timeFrom(profile));
      } else {
        await cancel();
      }
    } catch (_) {}
  }

  /// After checking in: no need to remind again today.
  Future<void> checkedInToday(Map<String, dynamic>? profile) async {
    if (!supported || profile == null || !isOn(profile)) return;
    try {
      await schedule(timeFrom(profile), skipToday: true);
    } catch (_) {}
  }
}
