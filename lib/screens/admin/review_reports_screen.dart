import 'package:flutter/material.dart';

import '../../models/post.dart' show timeAgo;
import '../../models/report.dart';
import '../../services/report_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';

/// Admin-only: review reported posts, comments and chat messages.
class ReviewReportsScreen extends StatelessWidget {
  const ReviewReportsScreen({super.key});

  Future<void> _remove(BuildContext context, Report r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove this ${r.type.label.toLowerCase()}?'),
        content: const Text('It will be deleted for everyone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ReportService.instance.removeContent(r);
      messenger.showSnackBar(const SnackBar(content: Text('Content removed.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t remove it. Try again.')));
    }
  }

  Future<void> _dismiss(BuildContext context, Report r) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ReportService.instance.dismiss(r);
      messenger.showSnackBar(const SnackBar(content: Text('Report dismissed.')));
    } catch (_) {
      messenger.showSnackBar(
          const SnackBar(content: Text('Couldn’t dismiss it. Try again.')));
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
              title: 'Reports',
              subtitle: 'Keep the community safe',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: StreamBuilder<List<Report>>(
                stream: ReportService.instance.open(),
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
                  final reports = snap.data!;
                  if (reports.isEmpty) {
                    return const EmptyState(
                      icon: Icons.verified_user_outlined,
                      title: 'No open reports',
                      message: 'Nothing needs your attention right now.',
                    );
                  }
                  return Column(
                    children: [
                      for (final r in reports)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _ReportCard(
                            report: r,
                            onRemove: () => _remove(context, r),
                            onDismiss: () => _dismiss(context, r),
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

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.report,
    required this.onRemove,
    required this.onDismiss,
  });

  final Report report;
  final VoidCallback onRemove;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final urgent = report.reason == ReportReason.selfHarm;
    final meta = AppText.caption.copyWith(color: AppColors.textMuted);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(report.type.label,
                    style: AppText.label.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text('in ${report.hubName}',
                    overflow: TextOverflow.ellipsis, style: meta),
              ),
              Text(timeAgo(report.createdAt), style: meta),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(report.reason.icon,
                  size: 18,
                  color: urgent ? AppColors.danger : AppColors.text),
              const SizedBox(width: 8),
              Expanded(
                child: Text(report.reason.label,
                    style: AppText.bodyStrong.copyWith(
                        color: urgent ? AppColors.danger : AppColors.text)),
              ),
            ],
          ),
          if (report.details.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text('“${report.details}”', style: meta),
          ],
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.authorName,
                    style: AppText.caption.copyWith(
                        color: AppColors.text, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(report.preview, style: AppText.body),
              ],
            ),
          ),
          if (urgent) ...[
            const SizedBox(height: 10),
            Text(
              'This member may need support. Consider checking in on them in '
              'the hub chat and sharing the NCMH Crisis Hotline (1553).',
              style: AppText.caption.copyWith(color: AppColors.primaryStrong),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Dismiss',
                  type: AppButtonType.secondary,
                  onPressed: onDismiss,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppButton(
                  label: 'Remove',
                  type: AppButtonType.danger,
                  onPressed: onRemove,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
