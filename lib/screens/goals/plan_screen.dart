import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/plan.dart';
import '../../services/goal_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';

void openPlan(BuildContext context, User user) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => PlanScreen(user: user),
  ));
}

/// "My plan": a private plan for hard moments, in the user's own words.
class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key, required this.user});

  final User user;

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final _reasons = TextEditingController();
  final _signs = TextEditingController();
  final _helps = TextEditingController();
  final _contactName = TextEditingController();
  final _contactPhone = TextEditingController();
  bool _loaded = false;
  bool _saving = false;
  RecoveryPlan _saved = const RecoveryPlan();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final plan = await GoalService.instance.plan(widget.user.uid).first;
      _saved = plan;
      _reasons.text = plan.reasons;
      _signs.text = plan.signs;
      _helps.text = plan.helps;
      _contactName.text = plan.contactName;
      _contactPhone.text = plan.contactPhone;
    } catch (_) {}
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    for (final c in [_reasons, _signs, _helps, _contactName, _contactPhone]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final plan = RecoveryPlan(
      reasons: _reasons.text,
      signs: _signs.text,
      helps: _helps.text,
      contactName: _contactName.text,
      contactPhone: _contactPhone.text,
    );
    try {
      await GoalService.instance.savePlan(widget.user.uid, plan);
      _saved = RecoveryPlan(
        reasons: plan.reasons.trim(),
        signs: plan.signs.trim(),
        helps: plan.helps.trim(),
        contactName: plan.contactName.trim(),
        contactPhone: plan.contactPhone.trim(),
      );
      messenger.showSnackBar(const SnackBar(content: Text('Your plan is saved.')));
      if (mounted) setState(() {});
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t save your plan. Try again.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _call() async {
    final number = _saved.contactPhone.replaceAll(RegExp(r'[^0-9+]'), '');
    if (number.isEmpty) return;
    await launchUrl(Uri(scheme: 'tel', path: number));
  }

  Widget _section({
    required IconData icon,
    required String title,
    required String help,
    required TextEditingController controller,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: AppText.title)),
            ],
          ),
          const SizedBox(height: 4),
          Text(help, style: AppText.caption.copyWith(color: AppColors.textMuted)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            minLines: 3,
            maxLines: 6,
            maxLength: 800,
            textCapitalization: TextCapitalization.sentences,
            style: AppText.body,
            decoration: _decoration(hint),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppText.body.copyWith(color: AppColors.textSubtle),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return BottomActionLayout(
      action: AppButton(label: 'Save my plan', loading: _saving, onPressed: _save),
      children: [
        ScreenHeader(
          title: 'My plan',
          subtitle: 'For hard moments. Only you can see this.',
          onBack: () => Navigator.of(context).pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_saved.contactName.isNotEmpty && _saved.contactPhone.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: AppCard(
                    color: AppColors.primaryTint,
                    bordered: false,
                    onTap: _call,
                    child: Row(
                      children: [
                        const IconTile(
                            icon: Icons.call_outlined,
                            size: 44,
                            color: AppColors.surface),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Call ${_saved.contactName}',
                                  style: AppText.bodyStrong),
                              Text(_saved.contactPhone,
                                  style: AppText.caption
                                      .copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Text(
                'Write this when you’re feeling okay, so it’s ready when '
                'things get hard. Use your own words. There are no wrong answers.',
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 20),
              _section(
                icon: Icons.favorite_border_rounded,
                title: 'Why I’m doing this',
                help: 'The people, dreams and reasons that keep you going.',
                controller: _reasons,
                hint: 'For my family, for my health, because I want to…',
              ),
              _section(
                icon: Icons.warning_amber_rounded,
                title: 'My warning signs',
                help: 'Feelings, places or situations that make things harder.',
                controller: _signs,
                hint: 'When I’m stressed, tired, lonely, or around…',
              ),
              _section(
                icon: Icons.self_improvement_rounded,
                title: 'What helps me',
                help: 'Things you can do instead: people, places, activities.',
                controller: _helps,
                hint: 'Go for a ride, message my hub, take a walk, call…',
              ),
              Row(
                children: [
                  const Icon(Icons.person_outline_rounded,
                      size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Someone I can call', style: AppText.title),
                ],
              ),
              const SizedBox(height: 4),
              Text('Optional: a friend, family member or sponsor.',
                  style: AppText.caption.copyWith(color: AppColors.textMuted)),
              const SizedBox(height: 8),
              TextField(
                controller: _contactName,
                textCapitalization: TextCapitalization.words,
                style: AppText.body,
                decoration: _decoration('Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contactPhone,
                keyboardType: TextInputType.phone,
                style: AppText.body,
                decoration: _decoration('Phone number'),
              ),
              const SizedBox(height: 20),
              AppCard(
                color: AppColors.accentTint,
                bordered: false,
                onTap: () => showHelpSheet(context),
                child: Row(
                  children: [
                    const Icon(Icons.support_outlined,
                        color: AppColors.primaryStrong),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'In crisis? The NCMH Crisis Hotline (1553) is free and '
                        'open 24/7. Tap for numbers.',
                        style: AppText.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
