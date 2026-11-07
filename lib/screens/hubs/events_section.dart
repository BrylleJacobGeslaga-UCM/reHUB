import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../models/hub_event.dart';
import '../../services/event_service.dart';
import '../../services/hub_request_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import 'create_event_screen.dart';

/// "Upcoming activities" on a hub page. Members only.
class EventsSection extends StatelessWidget {
  const EventsSection({
    super.key,
    required this.user,
    required this.hub,
    required this.joined,
    required this.myName,
  });

  final User user;
  final Hub hub;
  final bool joined;
  final String myName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: user.isAnonymous
          ? Stream.value(false)
          : HubRequestService.instance.isAdmin(user.uid),
      builder: (context, adminSnap) {
        final isAdmin = adminSnap.data == true;
        final canManage = isAdmin ||
            (!user.isAnonymous && hub.leaderId == user.uid);
        final canSee = joined || isAdmin;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.event_outlined,
                    size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                    child: Text('Upcoming activities', style: AppText.title)),
                if (canManage)
                  TextButton.icon(
                    onPressed: () => openCreateEvent(context,
                        user: user, hub: hub, myName: myName),
                    icon: const Icon(Icons.add_rounded,
                        size: 18, color: AppColors.primary),
                    label: Text('Add',
                        style: AppText.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (!canSee)
              _Note(
                icon: Icons.lock_outline_rounded,
                text: 'Join this hub to see its upcoming activities.',
              )
            else
              StreamBuilder<List<HubEvent>>(
                stream: EventService.instance.upcoming(hub.id),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    );
                  }
                  final events = snap.data!;
                  if (events.isEmpty) {
                    return _Note(
                      icon: Icons.event_available_outlined,
                      text: canManage
                          ? 'No activities yet. Tap “Add” to plan the first one.'
                          : 'No activities scheduled yet. Check back soon!',
                    );
                  }
                  return Column(
                    children: [
                      for (final e in events)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _EventCard(
                            event: e,
                            user: user,
                            myName: myName,
                            canRsvp: joined && !user.isAnonymous,
                            canManage: canManage,
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _Note extends StatelessWidget {
  const _Note({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSubtle),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: AppText.caption.copyWith(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({
    required this.event,
    required this.user,
    required this.myName,
    required this.canRsvp,
    required this.canManage,
  });

  final HubEvent event;
  final User user;
  final String myName;
  final bool canRsvp;
  final bool canManage;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  late final Stream<bool> _going = widget.canRsvp
      ? EventService.instance
          .isGoing(widget.user.uid, widget.event.hubId, widget.event.id)
      : Stream.value(false);
  bool _busy = false;

  void _show(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _toggle(bool going) async {
    setState(() => _busy = true);
    try {
      await EventService.instance.toggleGoing(
        uid: widget.user.uid,
        name: widget.myName,
        hubId: widget.event.hubId,
        eventId: widget.event.id,
      );
      if (!going) _show('See you there! Remember to meet in a public place.');
    } catch (_) {
      _show('Couldn’t update your RSVP. Try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete “${widget.event.title}”?'),
        content: const Text('Members will no longer see this activity.'),
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
      await EventService.instance
          .delete(widget.event.hubId, widget.event.id);
    } catch (_) {
      _show('Couldn’t delete the activity.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final meta = AppText.caption.copyWith(color: AppColors.textMuted);

    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 14, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(e.monthShort,
                        style: AppText.label.copyWith(color: AppColors.primary)),
                    Text('${e.startsAt.day}',
                        style: AppText.heading
                            .copyWith(color: AppColors.primaryStrong)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.title, style: AppText.bodyStrong),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 15, color: AppColors.textMuted),
                        const SizedBox(width: 6),
                        Flexible(child: Text(e.whenLabel, style: meta)),
                      ],
                    ),
                    if (e.place.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.place_outlined,
                              size: 15, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Flexible(child: Text(e.place, style: meta)),
                        ],
                      ),
                    ],
                    if (e.details.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(e.details, style: AppText.caption),
                    ],
                  ],
                ),
              ),
              if (widget.canManage)
                PopupMenuButton<String>(
                  tooltip: 'Activity options',
                  icon: const Icon(Icons.more_vert_rounded,
                      color: AppColors.textSubtle),
                  onSelected: (_) => _delete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'delete', child: Text('Delete activity')),
                  ],
                )
              else
                const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                const Icon(Icons.people_outline_rounded,
                    size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    e.goingCount == 0
                        ? 'Nobody yet'
                        : '${e.goingCount} going',
                    style: meta,
                  ),
                ),
                if (widget.canRsvp)
                  StreamBuilder<bool>(
                    stream: _going,
                    builder: (context, snap) {
                      final going = snap.data ?? false;
                      return SizedBox(
                        height: 40,
                        child: going
                            ? OutlinedButton.icon(
                                onPressed: _busy ? null : () => _toggle(true),
                                icon: const Icon(Icons.check_rounded, size: 18),
                                label: const Text('Going'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(
                                      color: AppColors.primarySoft, width: 1.5),
                                  shape: const StadiumBorder(),
                                ),
                              )
                            : FilledButton(
                                onPressed: _busy ? null : () => _toggle(false),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: const StadiumBorder(),
                                ),
                                child: const Text('I’m going'),
                              ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
