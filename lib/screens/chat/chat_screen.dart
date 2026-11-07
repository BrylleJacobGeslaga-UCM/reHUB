import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../models/message.dart';
import '../../services/chat_service.dart';
import '../../services/hub_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';
import '../auth/sign_up_screen.dart';
import '../hubs/discover_screen.dart';
import 'chat_room_screen.dart';

/// The Chat tab: one group chat per hub you've joined.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    final joined = List<String>.from(profile['joinedHubs'] ?? const []);

    Widget body;
    if (user.isAnonymous) {
      body = EmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'Hub chats are for members',
        message: 'Create an account and join a hub to chat with '
            'its members.',
        action: AppButton(
          label: 'Create an account',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SignUpScreen()),
          ),
        ),
      );
    } else if (joined.isEmpty) {
      body = EmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        title: 'No conversations yet',
        message: 'Each hub you join has a group chat. Join one to start '
            'talking.',
        action: AppButton(
          label: 'Explore hubs',
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => DiscoverScreen(user: user, joined: joined),
          )),
        ),
      );
    } else {
      body = StreamBuilder<List<Hub>>(
        stream: HubService.instance.hubs(),
        builder: (context, hubSnap) {
          final hubs = (hubSnap.data ?? const <Hub>[])
              .where((h) => joined.contains(h.id))
              .toList();
          return StreamBuilder<Map<String, DateTime>>(
            stream: ChatService.instance.reads(user.uid),
            builder: (context, readSnap) {
              final reads = readSnap.data ?? const {};
              return Column(
                children: [
                  for (final hub in hubs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ChatRow(
                        key: ValueKey(hub.id),
                        user: user,
                        hub: hub,
                        lastRead: reads[hub.id],
                      ),
                    ),
                ],
              );
            },
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ScreenHeader(
              title: 'Messages', subtitle: 'Connect with your hubs'),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: body,
          ),
        ],
      ),
    );
  }
}

class _ChatRow extends StatefulWidget {
  const _ChatRow({
    super.key,
    required this.user,
    required this.hub,
    required this.lastRead,
  });

  final User user;
  final Hub hub;
  final DateTime? lastRead;

  @override
  State<_ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<_ChatRow> {
  late final Stream<Message?> _latest =
      ChatService.instance.latest(widget.hub.id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Message?>(
      stream: _latest,
      builder: (context, snap) {
        final last = snap.data;
        final unread = last != null &&
            last.senderId != widget.user.uid &&
            (widget.lastRead == null || last.createdAt.isAfter(widget.lastRead!));
        final preview = last == null
            ? 'No messages yet. Say hi!'
            : last.senderId == widget.user.uid
                ? 'You: ${last.body}'
                : '${last.senderName.split(' ').first}: ${last.body}';

        return AppCard(
          onTap: () => openChatRoom(context, widget.user, widget.hub),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              IconTile(icon: widget.hub.icon, size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(widget.hub.name,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.title),
                        ),
                        if (last != null)
                          Text(shortStamp(last.createdAt),
                              style: AppText.caption.copyWith(
                                color: unread
                                    ? AppColors.primary
                                    : AppColors.textSubtle,
                                fontWeight:
                                    unread ? FontWeight.w700 : FontWeight.w500,
                              )),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            preview,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.caption.copyWith(
                              color: unread ? AppColors.text : AppColors.textMuted,
                              fontWeight:
                                  unread ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
