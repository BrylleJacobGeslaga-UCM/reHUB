import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../services/hub_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import '../chat/chat_room_screen.dart';

/// Opens a hub's page from anywhere in the app.
void openHub(BuildContext context, User user, String hubId) {
  Navigator.of(context).push(
    MaterialPageRoute(
        builder: (_) => HubDetailScreen(user: user, hubId: hubId)),
  );
}

class HubDetailScreen extends StatelessWidget {
  const HubDetailScreen({super.key, required this.user, required this.hubId});

  final User user;
  final String hubId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Hub?>(
      stream: HubService.instance.hub(hubId),
      builder: (context, hubSnap) {
        if (!hubSnap.hasData) {
          return Scaffold(
            body: Center(
              child: hubSnap.connectionState == ConnectionState.active
                  ? Text('This hub no longer exists.', style: AppText.body)
                  : const CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        final hub = hubSnap.data!;

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: UserService.instance.userDoc(user.uid),
          builder: (context, userSnap) {
            final profile = userSnap.data?.data() ?? const {};
            final joined =
                List<String>.from(profile['joinedHubs'] ?? const [])
                    .contains(hub.id);
            final name = (profile['name'] as String?) ??
                user.displayName ??
                'Member';

            return BottomActionLayout(
              action: _JoinButton(
                user: user,
                hub: hub,
                joined: joined,
                displayName: name,
              ),
              children: [
                ScreenHeader(
                  title: hub.name,
                  subtitle: '${hub.membersLabel} · ${hub.modeLabel}',
                  onBack: () => Navigator.of(context).pop(),
                  trailing: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(hub.icon, size: 34, color: AppColors.primary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('About', style: AppText.bodyStrong),
                            const SizedBox(height: 6),
                            Text(hub.description,
                                style: AppText.body
                                    .copyWith(color: AppColors.textMuted)),
                            if (hub.leaderName != null) ...[
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.verified_user_outlined,
                                      size: 16, color: AppColors.primary),
                                  const SizedBox(width: 6),
                                  Text('Started by ${hub.leaderName}',
                                      style: AppText.caption.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppCard(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          children: [
                            const IconTile(
                                icon: Icons.people_outline_rounded, size: 40),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                joined && hub.memberCount <= 1
                                    ? 'You’re the first member'
                                    : joined
                                    ? 'You and ${hub.memberCount - 1} '
                                        '${hub.memberCount - 1 == 1 ? 'other' : 'others'}'
                                    : hub.memberCount == 0
                                        ? 'Be the first to join'
                                        : hub.membersLabel,
                                style: AppText.bodyStrong,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (joined) ...[
                        const SizedBox(height: 14),
                        AppCard(
                          onTap: () => openChatRoom(context, user, hub),
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              const IconTile(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  size: 40),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Group chat',
                                        style: AppText.bodyStrong),
                                    Text('Talk with other members',
                                        style: AppText.caption.copyWith(
                                            color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(Icons.event_outlined,
                              size: 20, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('Upcoming activities', style: AppText.title),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppCard(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          'No activities scheduled yet. Meetups and '
                          'sessions will be posted here.',
                          style: AppText.caption
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _JoinButton extends StatefulWidget {
  const _JoinButton({
    required this.user,
    required this.hub,
    required this.joined,
    required this.displayName,
  });

  final User user;
  final Hub hub;
  final bool joined;
  final String displayName;

  @override
  State<_JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends State<_JoinButton> {
  bool _busy = false;

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _tap() async {
    if (widget.user.isAnonymous) {
      await showGuestPrompt(context, action: 'join hubs');
      return;
    }
    setState(() => _busy = true);
    try {
      if (widget.joined) {
        await HubService.instance
            .leave(user: widget.user, hubId: widget.hub.id);
        _show('You left ${widget.hub.name}.');
      } else {
        await HubService.instance.join(
          user: widget.user,
          displayName: widget.displayName,
          hubId: widget.hub.id,
        );
        _show('Welcome to ${widget.hub.name}!');
      }
    } catch (_) {
      _show('Something went wrong. Check your connection and try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: widget.joined ? 'Leave hub' : 'Join community',
      type: widget.joined ? AppButtonType.secondary : AppButtonType.primary,
      showIcon: !widget.joined,
      loading: _busy,
      onPressed: _tap,
    );
  }
}
