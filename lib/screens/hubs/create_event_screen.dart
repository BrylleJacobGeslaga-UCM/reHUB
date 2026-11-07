import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/checkin.dart' show longDate;
import '../../models/hub.dart';
import '../../models/message.dart' show clockTime;
import '../../services/event_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';

void openCreateEvent(
  BuildContext context, {
  required User user,
  required Hub hub,
  required String myName,
}) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CreateEventScreen(user: user, hub: hub, myName: myName),
  ));
}

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({
    super.key,
    required this.user,
    required this.hub,
    required this.myName,
  });

  final User user;
  final Hub hub;
  final String myName;

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  late final _place =
      TextEditingController(text: widget.hub.online ? 'Online · ' : '');
  final _details = TextEditingController();
  DateTime? _date;
  TimeOfDay? _time;
  late bool _publicPlace = widget.hub.online; // online needs no confirmation
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _details.dispose();
    super.dispose();
  }

  DateTime? get _startsAt => (_date == null || _time == null)
      ? null
      : DateTime(_date!.year, _date!.month, _date!.day, _time!.hour,
          _time!.minute);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      initialDate: _date ?? now,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    final startsAt = _startsAt;
    if (startsAt == null) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Pick a date and time.')));
      return;
    }
    if (!startsAt.isAfter(DateTime.now())) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Pick a time in the future.')));
      return;
    }
    setState(() => _saving = true);
    try {
      await EventService.instance.create(
        hubId: widget.hub.id,
        uid: widget.user.uid,
        createdByName: widget.myName,
        title: _title.text,
        startsAt: startsAt,
        place: _place.text,
        details: _details.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(
          content: Text('Added to ${widget.hub.name}. Members can RSVP now.')));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Couldn’t add the activity. Try again.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppText.body.copyWith(color: AppColors.textSubtle),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.5),
        ),
      );

  Widget _pickerTile({
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value ?? label,
              style: value == null
                  ? AppText.body.copyWith(color: AppColors.textSubtle)
                  : AppText.bodyStrong,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final online = widget.hub.online;

    return BottomActionLayout(
      action: AppButton(
        label: 'Add activity',
        loading: _saving,
        onPressed: _publicPlace ? _save : null,
      ),
      children: [
        ScreenHeader(
          title: 'New activity',
          subtitle: widget.hub.name,
          onBack: () => Navigator.of(context).pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('What’s happening?', style: AppText.title),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _title,
                  maxLength: 60,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.body,
                  decoration: _decoration(online
                      ? 'e.g. Co-op game night'
                      : 'e.g. Sunday sunrise ride'),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'At least 3 characters'
                      : null,
                ),
                const SizedBox(height: 8),
                Text('When', style: AppText.title),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _pickerTile(
                        icon: Icons.calendar_today_outlined,
                        label: 'Date',
                        value: _date == null ? null : longDate(_date!),
                        onTap: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 130,
                      child: _pickerTile(
                        icon: Icons.schedule_rounded,
                        label: 'Time',
                        value: _time == null
                            ? null
                            : clockTime(DateTime(2000, 1, 1, _time!.hour,
                                _time!.minute)),
                        onTap: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(online ? 'Where (link or platform)' : 'Where',
                    style: AppText.title),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _place,
                  maxLength: 100,
                  textCapitalization: TextCapitalization.words,
                  style: AppText.body,
                  decoration: _decoration(online
                      ? 'Online · Discord'
                      : 'e.g. IT Park, Lahug (meet at the main entrance)'),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'Tell members where to go'
                      : null,
                ),
                const SizedBox(height: 8),
                Text('Details', style: AppText.title),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _details,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 500,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.body,
                  decoration: _decoration(
                      'Optional: what to bring, pace, skill level…'),
                ),
                if (!online) ...[
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
                    onTap: () => setState(() => _publicPlace = !_publicPlace),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _publicPlace,
                          activeColor: AppColors.primary,
                          onChanged: (v) =>
                              setState(() => _publicPlace = v ?? false),
                        ),
                        Expanded(
                          child: Text(
                            'This meetup is in a public place, and it’s '
                            'substance-free.',
                            style: AppText.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
