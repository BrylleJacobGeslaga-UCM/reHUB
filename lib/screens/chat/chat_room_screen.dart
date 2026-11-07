import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../models/message.dart';
import '../../services/chat_service.dart';
import '../../services/user_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../models/report.dart';
import '../../widgets/app_card.dart';
import '../../widgets/report_sheet.dart';
import '../../widgets/screen_header.dart';

void openChatRoom(BuildContext context, User user, Hub hub) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => ChatRoomScreen(user: user, hub: hub),
  ));
}

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.user, required this.hub});

  final User user;
  final Hub hub;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _input = TextEditingController();
  late final Stream<List<Message>> _messages =
      ChatService.instance.messages(widget.hub.id);
  String _myName = 'Member';
  DateTime? _markedUpTo;

  @override
  void initState() {
    super.initState();
    _input.addListener(() => setState(() {}));
    _myName = widget.user.displayName ?? 'Member';
    _loadName();
  }

  /// Prefer the name saved in the profile.
  Future<void> _loadName() async {
    try {
      final d = await UserService.instance.userDoc(widget.user.uid).first;
      final n = d.data()?['name'] as String?;
      if (n != null && mounted) setState(() => _myName = n);
    } catch (_) {}
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  /// Marks the chat as read whenever a newer message arrives.
  void _markRead(List<Message> messages) {
    if (messages.isEmpty) return;
    final newest = messages.first.createdAt;
    if (_markedUpTo != null && !newest.isAfter(_markedUpTo!)) return;
    _markedUpTo = newest;
    ChatService.instance
        .markRead(uid: widget.user.uid, hubId: widget.hub.id)
        .catchError((_) {});
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    try {
      await ChatService.instance.send(
        hubId: widget.hub.id,
        uid: widget.user.uid,
        name: _myName,
        body: text,
      );
    } catch (_) {
      _input.text = text; // give it back so nothing is lost
      _show('Couldn’t send your message. Are you still a member?');
    }
  }

  Future<void> _delete(Message m) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this message?'),
        content: const Text('It will be removed for everyone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ChatService.instance
          .delete(hubId: widget.hub.id, messageId: m.id);
    } catch (_) {
      _show('Couldn’t delete the message.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _RoomHeader(hub: widget.hub),
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _messages,
              builder: (context, snap) {
                if (snap.hasError) {
                  return _Centered(
                    icon: Icons.lock_outline_rounded,
                    text: 'Only members of ${widget.hub.name} can see this '
                        'chat.',
                  );
                }
                if (!snap.hasData) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                final messages = snap.data!;
                _markRead(messages);

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  itemCount: messages.length + 1,
                  itemBuilder: (context, i) {
                    // The last item (drawn at the very top) is the banner.
                    if (i == messages.length) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _GuidelinesBanner(empty: messages.isEmpty),
                      );
                    }
                    final m = messages[i];
                    final older =
                        i + 1 < messages.length ? messages[i + 1] : null;
                    final mine = m.senderId == widget.user.uid;
                    final newDay =
                        older == null || !sameDay(older.createdAt, m.createdAt);
                    final showName = !mine &&
                        (newDay || older?.senderId != m.senderId);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (newDay) _DaySeparator(label: dayLabel(m.createdAt)),
                        _Bubble(
                          message: m,
                          mine: mine,
                          showName: showName,
                          onLongPress: mine
                              ? () => _delete(m)
                              : () => showReportSheet(
                                    context,
                                    user: widget.user,
                                    target: ReportTarget(
                                      type: ReportType.message,
                                      path: 'hubs/${widget.hub.id}/messages/${m.id}',
                                      hubId: widget.hub.id,
                                      hubName: widget.hub.name,
                                      preview: m.body,
                                      authorName: m.senderName,
                                    ),
                                  ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _Composer(
            controller: _input,
            onSend: _input.text.trim().isEmpty ? null : _send,
          ),
        ],
      ),
    );
  }
}

class _RoomHeader extends StatelessWidget {
  const _RoomHeader({required this.hub});
  final Hub hub;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 20, 16),
          child: Row(
            children: [
              HeaderIconButton(
                icon: Icons.arrow_back_rounded,
                tooltip: 'Back',
                onTap: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              IconTile(
                icon: hub.icon,
                size: 44,
                color: AppColors.surface,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hub.name,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.title.copyWith(color: Colors.white)),
                    Text('Group chat · ${hub.membersLabel}',
                        style: AppText.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.82))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuidelinesBanner extends StatelessWidget {
  const _GuidelinesBanner({required this.empty});
  final bool empty;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: AppColors.primaryTint,
      bordered: false,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.favorite_border_rounded,
              size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${empty ? 'Be the first to say hi! ' : ''}'
              'Be kind, keep it substance-free, and only meet up in '
              'public places.',
              style: AppText.caption.copyWith(color: AppColors.primaryStrong),
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(label,
              style: AppText.label.copyWith(color: AppColors.textMuted)),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
    required this.mine,
    required this.showName,
    this.onLongPress,
  });

  final Message message;
  final bool mine;
  final bool showName;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.75;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(mine ? 18 : 4),
      bottomRight: Radius.circular(mine ? 4 : 18),
    );

    return Padding(
      padding: EdgeInsets.only(top: showName ? 10 : 3),
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showName)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 3),
              child: Text(message.senderName,
                  style: AppText.label.copyWith(color: AppColors.primary)),
            ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Material(
              color: mine ? AppColors.primary : AppColors.surface,
              borderRadius: radius,
              child: InkWell(
                borderRadius: radius,
                onLongPress: onLongPress,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 9, 14, 7),
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: mine ? null : Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.body,
                        style: AppText.body.copyWith(
                            color: mine ? Colors.white : AppColors.text),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message.pending
                            ? 'Sending…'
                            : clockTime(message.createdAt),
                        style: AppText.label.copyWith(
                          fontWeight: FontWeight.w500,
                          color: mine
                              ? Colors.white.withValues(alpha: 0.75)
                              : AppColors.textSubtle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback? onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 1000,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppText.body,
                  onSubmitted: (_) => onSend?.call(),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Message',
                    hintStyle:
                        AppText.body.copyWith(color: AppColors.textSubtle),
                    filled: true,
                    fillColor: AppColors.bg,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                tooltip: 'Send',
                onPressed: onSend,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primarySoft,
                ),
                icon: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Centered extends StatelessWidget {
  const _Centered({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.textSubtle),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: AppText.body.copyWith(color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
