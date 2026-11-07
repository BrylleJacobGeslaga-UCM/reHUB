import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../services/hub_request_service.dart';
import '../../services/hub_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';

/// Shows who leads the hub. Admins can assign, change or remove the leader.
class LeaderCard extends StatelessWidget {
  const LeaderCard({super.key, required this.user, required this.hub});

  final User user;
  final Hub hub;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: user.isAnonymous
          ? Stream.value(false)
          : HubRequestService.instance.isAdmin(user.uid),
      builder: (context, snap) {
        final isAdmin = snap.data == true;
        final isMe = hub.leaderId == user.uid;

        return AppCard(
          padding: const EdgeInsets.fromLTRB(18, 14, 8, 14),
          child: Row(
            children: [
              IconTile(
                icon: hub.hasLeader
                    ? Icons.verified_user_outlined
                    : Icons.shield_outlined,
                size: 40,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hub leader',
                        style: AppText.caption
                            .copyWith(color: AppColors.textMuted)),
                    Text(
                      hub.hasLeader
                          ? (isMe ? '${hub.leaderName} (you)' : hub.leaderName!)
                          : 'Looked after by admins',
                      style: AppText.bodyStrong,
                    ),
                  ],
                ),
              ),
              if (isAdmin)
                TextButton(
                  onPressed: () => _showPicker(context),
                  child: Text(hub.hasLeader ? 'Change' : 'Assign',
                      style: AppText.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                )
              else
                const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }

  void _showPicker(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);

    Future<void> apply(BuildContext sheetContext,
        {String? uid, String? name}) async {
      Navigator.of(sheetContext).pop();
      try {
        await HubService.instance.setLeader(hub.id, uid: uid, name: name);
        messenger.showSnackBar(SnackBar(
          content: Text(uid == null
              ? '${hub.name} no longer has a leader.'
              : '$name is now the leader of ${hub.name}.'),
        ));
      } catch (_) {
        messenger.showSnackBar(const SnackBar(
            content: Text('Couldn’t change the leader. Try again.')));
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.75),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text('Choose a leader', style: AppText.heading),
                const SizedBox(height: 6),
                Text(
                  'Leaders can add and remove activities for ${hub.name}. '
                  'Only current members can be chosen.',
                  style: AppText.caption.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),
                StreamBuilder<List<({String uid, String name})>>(
                  stream: HubService.instance.members(hub.id),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        ),
                      );
                    }
                    final members = snap.data!;
                    if (members.isEmpty) {
                      return Text('This hub has no members yet.',
                          style: AppText.body
                              .copyWith(color: AppColors.textMuted));
                    }
                    return Column(
                      children: [
                        for (final m in members)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: AppCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              color: m.uid == hub.leaderId
                                  ? AppColors.primaryTint
                                  : AppColors.surface,
                              onTap: m.uid == hub.leaderId
                                  ? null
                                  : () => apply(sheetContext,
                                      uid: m.uid, name: m.name),
                              child: Row(
                                children: [
                                  const Icon(Icons.person_outline_rounded,
                                      color: AppColors.primary),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text(m.name,
                                          style: AppText.bodyStrong)),
                                  if (m.uid == hub.leaderId)
                                    Text('Current leader',
                                        style: AppText.label.copyWith(
                                            color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                if (hub.hasLeader) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => apply(sheetContext),
                    child: Text('Remove leader (admins look after it)',
                        style: AppText.bodyStrong
                            .copyWith(color: AppColors.danger)),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
