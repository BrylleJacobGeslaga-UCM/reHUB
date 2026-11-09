import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/message.dart' show clockTime;
import '../../services/reminder_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Settings row: daily check-in reminder on/off + time.
class ReminderRow extends StatefulWidget {
  const ReminderRow({super.key, required this.user});
  final User user;

  @override
  State<ReminderRow> createState() => _ReminderRowState();
}

class _ReminderRowState extends State<ReminderRow> {
  late final _profile = UserService.instance.userDoc(widget.user.uid);
  bool _busy = false;

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _apply(bool on, TimeOfDay time) async {
    setState(() => _busy = true);
    final rs = ReminderService.instance;
    try {
      if (on) {
        final allowed = await rs.requestPermission();
        if (!allowed) {
          _show('Notifications are turned off for reHUB. You can allow '
              'them in your phone’s Settings → Apps → reHUB.');
          return;
        }
        await rs.schedule(time);
      } else {
        await rs.cancel();
      }
      await rs.save(widget.user.uid, on: on, time: time);
      if (on) {
        _show('Reminder set for ${_label(time)} every day.');
      }
    } catch (_) {
      _show('Couldn’t update the reminder. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _label(TimeOfDay t) =>
      clockTime(DateTime(2000, 1, 1, t.hour, t.minute));

  Future<void> _pickTime(TimeOfDay current) async {
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked != null) await _apply(true, picked);
  }

  @override
  Widget build(BuildContext context) {
    if (!ReminderService.instance.supported) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.notifications_none_rounded,
                size: 22, color: AppColors.primary),
            const SizedBox(width: 20),
            Expanded(
              child: Text('Daily reminders are available in the Android app.',
                  style: AppText.caption.copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _profile,
      builder: (context, snap) {
        final profile = snap.data?.data() ?? const <String, dynamic>{};
        final on = ReminderService.isOn(profile);
        final time = ReminderService.timeFrom(profile);

        return InkWell(
          onTap: _busy || !on ? null : () => _pickTime(time),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            child: Row(
              children: [
                const Icon(Icons.notifications_none_rounded,
                    size: 22, color: AppColors.primary),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daily check-in reminder',
                          style: AppText.bodyStrong),
                      Text(
                        on
                            ? 'Every day at ${_label(time)} · tap to change'
                            : 'A gentle nudge to check in',
                        style: AppText.caption.copyWith(
                            color:
                                on ? AppColors.primary : AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: on,
                  activeTrackColor: AppColors.primary,
                  onChanged: _busy ? null : (v) => _apply(v, time),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
