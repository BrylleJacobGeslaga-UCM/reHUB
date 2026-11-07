import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/checkin.dart';
import '../../services/checkin_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';

void openCheckIn(BuildContext context, User user, {CheckIn? existing}) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckInScreen(user: user, existing: existing),
  ));
}

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key, required this.user, this.existing});

  final User user;

  /// Today's check-in if the user already did one (they're editing it).
  final CheckIn? existing;

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late Mood? _mood = widget.existing?.mood;
  late final _note = TextEditingController(text: widget.existing?.note ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final mood = _mood;
    if (mood == null) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await CheckInService.instance.saveToday(widget.user.uid, mood, _note.text);
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(
        content: Text(mood == Mood.struggling
            ? 'Thanks for being honest today. Your hub is here for you.'
            : 'Check-in saved. Nice work showing up today.'),
      ));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Couldn’t save your check-in. Try again.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;

    return BottomActionLayout(
      action: AppButton(
        label: editing ? 'Update check-in' : 'Complete check-in',
        loading: _saving,
        onPressed: _mood == null ? null : _save,
      ),
      children: [
        ScreenHeader(
          title: 'Daily check-in',
          subtitle: longDate(DateTime.now()),
          onBack: () => Navigator.of(context).pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('How are you feeling today?', style: AppText.title),
              const SizedBox(height: 12),
              Row(
                children: [
                  for (final m in Mood.values) ...[
                    if (m != Mood.values.first) const SizedBox(width: 12),
                    Expanded(
                      child: _MoodCard(
                        mood: m,
                        selected: _mood == m,
                        onTap: () => setState(() => _mood = m),
                      ),
                    ),
                  ],
                ],
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: _mood == Mood.struggling
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: AppCard(
                          color: AppColors.accentTint,
                          bordered: false,
                          onTap: () => showHelpSheet(context),
                          child: Row(
                            children: [
                              const Icon(Icons.support_outlined,
                                  color: AppColors.primaryStrong),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Having a hard day?',
                                        style: AppText.bodyStrong),
                                    Text(
                                      'Reach out to your hub, or talk to a '
                                      'trained responder, free and 24/7.',
                                      style: AppText.caption.copyWith(
                                          color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('What’s on your mind?', style: AppText.title),
                  const SizedBox(width: 8),
                  Text('Optional',
                      style:
                          AppText.caption.copyWith(color: AppColors.textSubtle)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _note,
                minLines: 5,
                maxLines: 8,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
                style: AppText.body,
                decoration: InputDecoration(
                  hintText: 'Share your thoughts, feelings, or what you’re '
                      'grateful for today…',
                  hintStyle: AppText.body.copyWith(color: AppColors.textSubtle),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.lock_outline_rounded,
                      size: 14, color: AppColors.textSubtle),
                  const SizedBox(width: 6),
                  Text('Only you can see your check-ins.',
                      style:
                          AppText.caption.copyWith(color: AppColors.textSubtle)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final Mood mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.border,
        width: selected ? 2 : 1,
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: mood.label,
      child: Material(
        color: selected ? AppColors.primaryTint : AppColors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(mood.icon,
                    size: 36,
                    color: selected ? AppColors.primary : AppColors.textMuted),
                const SizedBox(height: 8),
                Text(
                  mood.label,
                  style: AppText.bodyStrong.copyWith(
                    fontSize: 14,
                    color: selected ? AppColors.primaryStrong : AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
