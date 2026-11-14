import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/avatar.dart';
import '../../models/post.dart' show initialsOf;
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/post_card.dart' show Avatar;
import '../../widgets/screen_header.dart';

void openEditProfile(
    BuildContext context, User user, Map<String, dynamic> profile) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => EditProfileScreen(user: user, profile: profile),
  ));
}

/// Change your name and pick an avatar (icon + color).
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(
      text: (widget.profile['name'] as String?) ??
          widget.user.displayName ??
          '');
  late final AvatarStyle? _original = AvatarStyle.of(widget.profile);
  late String? _iconId = _original?.iconId;
  late String _colorId = _original?.colorId ?? 'mint';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  AvatarStyle? get _avatar =>
      _iconId == null ? null : AvatarStyle(_iconId!, _colorId);

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await UserService.instance.updateProfile(
        user: widget.user,
        name: _name.text,
        avatar: _avatar?.code,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(const SnackBar(content: Text('Profile saved.')));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Couldn’t save your profile. Try again.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = _name.text.trim();

    return BottomActionLayout(
      action: AppButton(label: 'Save', onPressed: _save, loading: _saving),
      children: [
        ScreenHeader(
          title: 'Edit profile',
          subtitle: 'How others see you in hubs',
          onBack: () => Navigator.of(context).pop(),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Live preview
                Center(
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(_avatar?.code),
                    tween: Tween(begin: 0.85, end: 1),
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.elasticOut,
                    builder: (context, s, child) =>
                        Transform.scale(scale: s, child: child),
                    child: Avatar(
                      initials: initialsOf(name.isEmpty ? '?' : name),
                      anonymous: false,
                      avatar: _avatar,
                      size: 96,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name.isEmpty ? 'Your name' : name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.title,
                ),
                const SizedBox(height: 24),

                AppTextField(
                  label: 'Name',
                  hint: 'What should we call you?',
                  icon: Icons.person_outline_rounded,
                  controller: _name,
                  maxLength: maxNameLength,
                  textInputAction: TextInputAction.done,
                  validator: (v) => (v == null || v.trim().length < 2)
                      ? 'Enter at least 2 characters'
                      : null,
                ),
                const SizedBox(height: 4),
                Text(
                  'New posts and comments use your new name. Older ones keep '
                  'the name they were posted with.',
                  style: AppText.caption.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),

                Text('Avatar', style: AppText.title),
                const SizedBox(height: 10),
                AppCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LayoutBuilder(builder: (context, box) {
                        const perRow = 5;
                        const gap = 10.0;
                        final size = (box.maxWidth - gap * (perRow - 1)) / perRow;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            // Initials (no icon)
                            _Choice(
                              size: size,
                              selected: _iconId == null,
                              semantics: 'Initials',
                              onTap: () => setState(() => _iconId = null),
                              child: Avatar(
                                initials: initialsOf(
                                    name.isEmpty ? '?' : name),
                                anonymous: false,
                                size: size - 8,
                              ),
                            ),
                            for (final e in avatarIcons.entries)
                              _Choice(
                                size: size,
                                selected: _iconId == e.key,
                                semantics: e.key,
                                onTap: () => setState(() => _iconId = e.key),
                                child: Avatar(
                                  initials: '',
                                  anonymous: false,
                                  avatar: AvatarStyle(e.key, _colorId),
                                  size: size - 8,
                                ),
                              ),
                          ],
                        );
                      }),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: _iconId == null
                            ? const SizedBox(width: double.infinity)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 16),
                                  const Divider(
                                      height: 1, color: AppColors.border),
                                  const SizedBox(height: 14),
                                  Text('Color',
                                      style: AppText.caption.copyWith(
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 10),
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      for (final e in avatarColors.entries)
                                        _ColorDot(
                                          color: e.value,
                                          selected: _colorId == e.key,
                                          label: e.key,
                                          onTap: () => setState(
                                              () => _colorId = e.key),
                                        ),
                                    ],
                                  ),
                                ],
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
    required this.size,
    required this.selected,
    required this.semantics,
    required this.onTap,
    required this.child,
  });

  final double size;
  final bool selected;
  final String semantics;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semantics,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final AvatarColor color;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.background,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 3 : 1,
            ),
          ),
          child: selected
              ? Icon(Icons.check_rounded, size: 20, color: color.foreground)
              : null,
        ),
      ),
    );
  }
}
