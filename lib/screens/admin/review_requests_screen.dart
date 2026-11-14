import 'package:flutter/material.dart';

import '../../models/hub_request.dart';
import '../../services/hub_request_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/request_status.dart';
import '../../widgets/screen_header.dart';

/// Admin-only: approve or decline suggested hubs.
class ReviewRequestsScreen extends StatelessWidget {
  const ReviewRequestsScreen({super.key, this.embedded = false});

  /// True when shown as a tab inside the Admin screen (no header).
  final bool embedded;

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
    final reason = await showDeclineSheet(context, r);
    if (reason == null || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await HubRequestService.instance.decline(r, note: reason);
      messenger.showSnackBar(
          SnackBar(content: Text('Declined “${r.name}”.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t decline. Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = Padding(
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
      );
    if (embedded) return SingleChildScrollView(child: list);
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
            list,
          ],
        ),
      ),
    );
  }
}

const _quickReasons = [
  'A similar hub already exists',
  'Too broad or unclear',
  'Doesn’t fit reHUB’s guidelines',
  'Not enough detail yet',
];

/// Asks the admin why a suggestion is declined. Returns the reason text
/// ('' for none), or null if they cancelled.
Future<String?> showDeclineSheet(BuildContext context, HubRequest r) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (context) => _DeclineSheet(request: r),
  );
}

class _DeclineSheet extends StatefulWidget {
  const _DeclineSheet({required this.request});
  final HubRequest request;

  @override
  State<_DeclineSheet> createState() => _DeclineSheetState();
}

class _DeclineSheetState extends State<_DeclineSheet> {
  final _note = TextEditingController();
  String? _picked;

  @override
  void initState() {
    super.initState();
    _note.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  /// "A similar hub already exists. Try joining Book Nook!"
  String get _reason {
    final note = _note.text.trim();
    final picked = _picked;
    if (picked == null) return note;
    if (note.isEmpty) return picked;
    return '$picked. $note';
  }

  @override
  Widget build(BuildContext context) {
    final reason = _reason;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 12, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Decline “${widget.request.name}”?',
                style: AppText.heading),
            const SizedBox(height: 4),
            Text(
              '${widget.request.requesterName} will see the reason under '
              'My requests. A kind reason helps them try again.',
              style: AppText.caption.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final q in _quickReasons)
                  ChoiceChip(
                    label: Text(q),
                    selected: _picked == q,
                    onSelected: (on) =>
                        setState(() => _picked = on ? q : null),
                    showCheckmark: false,
                    labelStyle: AppText.caption.copyWith(
                      color: _picked == q
                          ? AppColors.primary
                          : AppColors.textMuted,
                      fontWeight:
                          _picked == q ? FontWeight.w700 : FontWeight.w600,
                    ),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primaryTint,
                    side: BorderSide(
                        color: _picked == q
                            ? AppColors.primarySoft
                            : AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _note,
              maxLength: 200,
              maxLines: 3,
              minLines: 2,
              style: AppText.body,
              decoration: InputDecoration(
                hintText: _picked == null
                    ? 'Write a reason (optional)'
                    : 'Add a note (optional), e.g. “Try joining Book Nook!”',
                hintStyle: AppText.body.copyWith(color: AppColors.textSubtle),
                filled: true,
                fillColor: AppColors.surface,
                counterStyle:
                    AppText.label.copyWith(color: AppColors.textSubtle),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.border, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            if (reason.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('They’ll see: “$reason”',
                  style: AppText.caption.copyWith(color: AppColors.textMuted)),
            ],
            const SizedBox(height: 16),
            AppButton(
              label: reason.isEmpty ? 'Decline without a reason' : 'Decline',
              type: AppButtonType.danger,
              onPressed: () => Navigator.pop(context, reason),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: AppText.bodyStrong
                      .copyWith(color: AppColors.textMuted)),
            ),
          ],
        ),
      ),
    );
  }
}
