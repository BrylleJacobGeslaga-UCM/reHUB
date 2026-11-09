import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub_request.dart';
import '../../services/hub_request_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/request_status.dart';
import '../../widgets/screen_header.dart';
import 'hub_detail_screen.dart';

void openMyRequests(BuildContext context, User user) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => MyRequestsScreen(user: user),
  ));
}

/// The hubs you've suggested and their review status.
class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key, required this.user});

  final User user;

  Future<void> _withdraw(BuildContext context, HubRequest r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Withdraw “${r.name}”?'),
        content: const Text('Your suggestion will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep it')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Withdraw',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok == true) await HubRequestService.instance.cancel(r.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Your suggestions',
              subtitle: 'Hubs you’ve suggested',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: StreamBuilder<List<HubRequest>>(
                stream: HubRequestService.instance.myRequests(user.uid),
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
                  final requests = snap.data!;
                  if (requests.isEmpty) {
                    return const EmptyState(
                      icon: Icons.outbox_outlined,
                      title: 'No suggestions yet',
                      message: 'Suggest a hub from the Discover screen.',
                    );
                  }
                  return Column(
                    children: [
                      for (final r in requests)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: RequestCard(
                            request: r,
                            onTap: r.status == RequestStatus.approved &&
                                    r.hubId != null
                                ? () => openHub(context, user, r.hubId!)
                                : null,
                            actions: r.status == RequestStatus.pending
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () => _withdraw(context, r),
                                      child: Text('Withdraw',
                                          style: AppText.caption.copyWith(
                                              color: AppColors.danger,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                  )
                                : null,
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
