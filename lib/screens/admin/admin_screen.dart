import 'package:flutter/material.dart';

import '../../models/hub_request.dart';
import '../../models/report.dart';
import '../../services/hub_request_service.dart';
import '../../services/report_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/screen_header.dart';
import 'review_reports_screen.dart';
import 'review_requests_screen.dart';

void openAdmin(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const AdminScreen()),
  );
}

/// Admin home: reports and hub requests as two tabs.
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Admin',
              subtitle: 'Keep reHUB safe and growing',
              onBack: () => Navigator.of(context).pop(),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: AppColors.primaryTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: AppColors.primaryStrong,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle:
                    AppText.caption.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: AppText.caption,
                tabs: [
                  StreamBuilder<List<Report>>(
                    stream: ReportService.instance.open(),
                    builder: (context, snap) =>
                        _TabLabel('Reports', snap.data?.length ?? 0),
                  ),
                  StreamBuilder<List<HubRequest>>(
                    stream: HubRequestService.instance.pending(),
                    builder: (context, snap) =>
                        _TabLabel('Hub requests', snap.data?.length ?? 0),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  ReviewReportsScreen(embedded: true),
                  ReviewRequestsScreen(embedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel(this.text, this.count);
  final String text;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 44,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('$count',
                  style: AppText.label.copyWith(color: Colors.white)),
            ),
          ],
        ],
      ),
    );
  }
}

/// Header button for admins: a shield with a badge for waiting items.
/// Shows nothing for everyone else.
class AdminHeaderButton extends StatelessWidget {
  const AdminHeaderButton({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: HubRequestService.instance.isAdmin(uid),
      builder: (context, adminSnap) {
        if (adminSnap.data != true) return const SizedBox.shrink();
        return StreamBuilder<List<Report>>(
          stream: ReportService.instance.open(),
          builder: (context, reports) => StreamBuilder<List<HubRequest>>(
            stream: HubRequestService.instance.pending(),
            builder: (context, requests) {
              final waiting =
                  (reports.data?.length ?? 0) + (requests.data?.length ?? 0);
              return Badge(
                isLabelVisible: waiting > 0,
                label: Text('$waiting'),
                backgroundColor: AppColors.accent,
                textColor: AppColors.text,
                child: HeaderIconButton(
                  icon: Icons.admin_panel_settings_outlined,
                  tooltip: 'Admin',
                  onTap: () => openAdmin(context),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
