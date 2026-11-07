import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../services/hub_service.dart';
import '../../services/post_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';

class ComposeScreen extends StatefulWidget {
  const ComposeScreen({super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  @override
  State<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen> {
  final _body = TextEditingController();
  String? _hubId;
  bool _anonymous = false;
  bool _posting = false;

  List<String> get _joined =>
      List<String>.from(widget.profile['joinedHubs'] ?? const []);

  @override
  void initState() {
    super.initState();
    _body.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _post(Hub hub) async {
    setState(() => _posting = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await PostService.instance.create(
        uid: widget.user.uid,
        hub: hub,
        body: _body.text,
        anonymous: _anonymous,
        authorName: (widget.profile['name'] as String?) ??
            widget.user.displayName ??
            'Member',
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
          SnackBar(content: Text('Posted to ${hub.name}. Thanks for sharing!')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Couldn’t post: $e')));
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Hub>>(
      stream: HubService.instance.hubs(),
      builder: (context, snap) {
        final hubs = (snap.data ?? const <Hub>[])
            .where((h) => _joined.contains(h.id))
            .toList();
        final selected = hubs.where((h) => h.id == _hubId).firstOrNull ??
            hubs.firstOrNull;
        final canPost =
            selected != null && _body.text.trim().isNotEmpty && !_posting;

        return BottomActionLayout(
          action: AppButton(
            label: 'Post update',
            loading: _posting,
            onPressed: canPost ? () => _post(selected!) : null,
          ),
          children: [
            ScreenHeader(
              title: 'Create update',
              subtitle: 'Share your progress with a hub',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Select hub', style: AppText.title),
                  const SizedBox(height: 10),
                  if (snap.hasData && hubs.isEmpty)
                    Text(
                      'Join a hub first. Updates are shared with the members '
                      'of a hub you’re part of.',
                      style: AppText.caption
                          .copyWith(color: AppColors.textMuted),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final h in hubs)
                          _HubChoice(
                            hub: h,
                            selected: h.id == selected?.id,
                            onTap: () => setState(() => _hubId = h.id),
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  Text('Share your update', style: AppText.title),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _body,
                    minLines: 5,
                    maxLines: 10,
                    maxLength: 1000,
                    textCapitalization: TextCapitalization.sentences,
                    style: AppText.body,
                    decoration: InputDecoration(
                      hintText: 'A win, a struggle, something you’re '
                          'grateful for…',
                      hintStyle:
                          AppText.body.copyWith(color: AppColors.textSubtle),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: AppColors.border, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border_rounded,
                          size: 14, color: AppColors.textSubtle),
                      const SizedBox(width: 6),
                      Text('Keep it supportive and encouraging',
                          style: AppText.caption
                              .copyWith(color: AppColors.textSubtle)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        const IconTile(icon: Icons.shield_outlined, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Post anonymously',
                                  style: AppText.bodyStrong),
                              Text('Your name won’t be shown on this post',
                                  style: AppText.caption.copyWith(
                                      color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        Switch(
                          value: _anonymous,
                          activeTrackColor: AppColors.primary,
                          onChanged: (v) => setState(() => _anonymous = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HubChoice extends StatelessWidget {
  const _HubChoice({
    required this.hub,
    required this.selected,
    required this.onTap,
  });

  final Hub hub;
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
                Icon(hub.icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(hub.name,
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
