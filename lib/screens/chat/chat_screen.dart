import 'dart:async';

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
            builder: (context, readSnap) => _ChatList(
              user: user,
              hubs: hubs,
              reads: readSnap.data ?? const {},
            ),
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

/// The chats, newest conversation first (like Messenger). Hubs with no
/// messages yet go last, by name. Rows glide to their new place when the
/// order changes.
class _ChatList extends StatefulWidget {
  const _ChatList({
    required this.user,
    required this.hubs,
    required this.reads,
  });

  final User user;
  final List<Hub> hubs;
  final Map<String, DateTime> reads;

  @override
  State<_ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<_ChatList> {
  final _subs = <String, StreamSubscription<Message?>>{};
  final _latest = <String, Message?>{};

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(_ChatList old) {
    super.didUpdateWidget(old);
    _sync();
  }

  /// Listens to the newest message of every joined hub (and stops for
  /// hubs you left).
  void _sync() {
    final ids = widget.hubs.map((h) => h.id).toSet();
    for (final id in _subs.keys.toList()) {
      if (!ids.contains(id)) {
        _subs.remove(id)?.cancel();
        _latest.remove(id);
      }
    }
    for (final id in ids) {
      _subs.putIfAbsent(
        id,
        () => ChatService.instance.latest(id).listen(
              (m) {
                if (mounted) setState(() => _latest[id] = m);
              },
              onError: (_) {},
            ),
      );
    }
  }

  @override
  void dispose() {
    for (final s in _subs.values) {
      s.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hubs = [...widget.hubs]..sort((a, b) {
        final ma = _latest[a.id];
        final mb = _latest[b.id];
        if (ma != null && mb != null) {
          return mb.createdAt.compareTo(ma.createdAt);
        }
        if (ma != null) return -1;
        if (mb != null) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

    // Every row is the same height, so rows can glide when they reorder.
    // (Grows with the phone's font size setting.)
    final scale = MediaQuery.textScalerOf(context);
    final text = scale.scale(24) + 2 + scale.scale(18);
    final double cardHeight = 28.0 + (text > 52.0 ? text : 52.0);
    final rowHeight = cardHeight + 12;
    return SizedBox(
      height: rowHeight * hubs.length,
      child: Stack(
        children: [
          for (var i = 0; i < hubs.length; i++)
            AnimatedPositioned(
              key: ValueKey(hubs[i].id),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              top: rowHeight * i,
              left: 0,
              right: 0,
              height: rowHeight - 12,
              child: _ChatRow(
                user: widget.user,
                hub: hubs[i],
                last: _latest[hubs[i].id],
                lastRead: widget.reads[hubs[i].id],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  const _ChatRow({
    required this.user,
    required this.hub,
    required this.last,
    required this.lastRead,
  });

  final User user;
  final Hub hub;
  final Message? last;
  final DateTime? lastRead;

  @override
  Widget build(BuildContext context) {
    final last = this.last;
    final unread = last != null &&
        last.senderId != user.uid &&
        (lastRead == null || last.createdAt.isAfter(lastRead!));
    final preview = last == null
        ? 'No messages yet. Say hi!'
        : last.senderId == user.uid
            ? 'You: ${last.body}'
            : '${last.senderName.split(' ').first}: ${last.body}';

    return AppCard(
      onTap: () => openChatRoom(context, user, hub),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconTile(icon: hub.icon, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(hub.name,
                          maxLines: 1,
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
  }
}
