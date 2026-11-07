import 'package:flutter/material.dart';

import '../../models/hub_request.dart';
import '../../services/hub_request_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/request_status.dart';
import '../../widgets/screen_header.dart';

/// Admin-only: approve or decline suggested hubs.
class ReviewRequestsScreen extends StatelessWidget {
  const ReviewRequestsScreen({super.key});

  Future<void> _approve(BuildContext context, HubRequest r) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await HubRequestService.instance.approve(r);
      messenger.showSnackBar(
          SnackBar(content: Text('“${r.name}” is now live.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t approve. Try again.')));
    }
  }

  Future<void> _decline(BuildContext context, HubRequest r) async {
    final note = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Decline “${r.name}”?'),
        content: TextField(
          controller: note,
          maxLength: 200,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Reason (optional, shown to the member)',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Decline',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await HubRequestService.instance.decline(r, note: note.text);
      messenger.showSnackBar(
          SnackBar(content: Text('Declined “${r.name}”.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t decline. Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Hub requests',
              subtitle: 'Review suggestions from members',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: StreamBuilder<List<HubRequest>>(
                stream: HubRequestService.instance.pending(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return const EmptyState(
                      icon: Icons.lock_outline_rounded,
                      title: 'Admins only',
                      message: 'Your account doesn’t have admin access.',
                    );
                  }
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
                      icon: Icons.inbox_outlined,
                      title: 'All caught up',
                      message: 'No hub suggestions are waiting for review.',
                    );
                  }
                  return Column(
                    children: [
                      for (final r in requests)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: RequestCard(
                            request: r,
                            showRequester: true,
                            actions: Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    label: 'Decline',
                                    type: AppButtonType.danger,
                                    onPressed: () => _decline(context, r),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: AppButton(
                                    label: 'Approve',
                                    onPressed: () => _approve(context, r),
                                  ),
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
