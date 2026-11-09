import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/block_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';

void openBlocked(BuildContext context, User user) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => BlockedScreen(user: user),
  ));
}

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Blocked members',
              subtitle: 'Only you can see this list',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: StreamBuilder<Map<String, String>>(
                stream: BlockService.instance.blocked(user.uid),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary),
                      ),
                    );
                  }
                  final blocked = snap.data!.entries.toList()
                    ..sort((a, b) =>
                        a.value.toLowerCase().compareTo(b.value.toLowerCase()));
                  if (blocked.isEmpty) {
                    return const EmptyState(
                      icon: Icons.block_outlined,
                      title: 'No one is blocked',
                      message: 'You can block a member from the ⋮ menu on '
                          'their post or comment, or by long-pressing their '
                          'chat message.',
                    );
                  }
                  return Column(
                    children: [
                      for (final b in blocked)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AppCard(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Row(
                              children: [
                                const Icon(Icons.person_off_outlined,
                                    color: AppColors.textMuted),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: Text(b.value,
                                        style: AppText.bodyStrong)),
                                TextButton(
                                  onPressed: () => BlockService.instance
                                      .unblock(user.uid, b.key),
                                  child: Text('Unblock',
                                      style: AppText.caption.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
