import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/onboarding_options.dart';
import '../../services/hub_request_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';

void openRequestHub(BuildContext context, User user, String requesterName) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) =>
        RequestHubScreen(user: user, requesterName: requesterName),
  ));
}

class RequestHubScreen extends StatefulWidget {
  const RequestHubScreen({
    super.key,
    required this.user,
    required this.requesterName,
  });

  final User user;
  final String requesterName;

  @override
  State<RequestHubScreen> createState() => _RequestHubScreenState();
}

class _RequestHubScreenState extends State<RequestHubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  String? _interest;
  bool _online = false;
  bool _agreed = false;
  bool _sending = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    if (_interest == null) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Pick the activity this hub is about.')));
      return;
    }
    setState(() => _sending = true);
    try {
      await HubRequestService.instance.submit(
        uid: widget.user.uid,
        requesterName: widget.requesterName,
        name: _name.text,
        interest: _interest!,
        online: _online,
        description: _description.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(const SnackBar(
          content: Text('Thanks! Your hub is waiting for review. '
              'You can check its status on your Profile.')));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Couldn’t send your request. Try again.')));
    } finally {
      if (mounted) setState(() => _sending = false);
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

  @override
  Widget build(BuildContext context) {
    return BottomActionLayout(
      action: AppButton(
        label: 'Send for review',
        loading: _sending,
        onPressed: _agreed ? _submit : null,
      ),
      children: [
        ScreenHeader(
          title: 'Suggest a hub',
          subtitle: 'New hubs are reviewed before they go live',
          onBack: () => Navigator.of(context).pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Hub name', style: AppText.title),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _name,
                  maxLength: 40,
                  textCapitalization: TextCapitalization.words,
                  style: AppText.body,
                  decoration: _decoration('e.g. Sunday Swimmers'),
                  validator: (v) => (v == null || v.trim().length < 3)
                      ? 'At least 3 characters'
                      : null,
                ),
                const SizedBox(height: 12),
                Text('Activity', style: AppText.title),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final o in interestOptions)
                      _Choice(
                        label: o.label,
                        icon: o.icon,
                        selected: _interest == o.id,
                        onTap: () => setState(() => _interest = o.id),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Where does it meet?', style: AppText.title),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Choice(
                      label: 'Outdoors',
                      icon: Icons.wb_sunny_outlined,
                      selected: !_online,
                      onTap: () => setState(() => _online = false),
                    ),
                    const SizedBox(width: 8),
                    _Choice(
                      label: 'Online',
                      icon: Icons.public_rounded,
                      selected: _online,
                      onTap: () => setState(() => _online = true),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('About this hub', style: AppText.title),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _description,
                  minLines: 4,
                  maxLines: 6,
                  maxLength: 300,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.body,
                  decoration: _decoration(
                      'What will members do together? Who is it for?'),
                  validator: (v) => (v == null || v.trim().length < 20)
                      ? 'Tell people a bit more (at least 20 characters)'
                      : null,
                ),
                const SizedBox(height: 8),
                AppCard(
                  padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
                  onTap: () => setState(() => _agreed = !_agreed),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _agreed,
                        activeColor: AppColors.primary,
                        onChanged: (v) => setState(() => _agreed = v ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'This hub will be a supportive, substance-free '
                          'space, and meetups will be in public places.',
                          style: AppText.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final shape = StadiumBorder(
      side: BorderSide(
        color: selected ? AppColors.primary : AppColors.border,
        width: selected ? 2 : 1,
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.primaryTint : AppColors.surface,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 16, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(label,
                    style: AppText.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          selected ? AppColors.primaryStrong : AppColors.text,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
