import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/onboarding_options.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/checkin_summary.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import '../../models/hub.dart';
import '../../services/hub_service.dart';
import '../../widgets/hub_row.dart';
import '../auth/sign_up_screen.dart';
import '../../models/hub_request.dart';
import '../../services/hub_request_service.dart';
import '../../widgets/request_status.dart';
import '../../models/report.dart';
import '../../services/report_service.dart';
import '../admin/review_reports_screen.dart';
import '../goals/goals_screen.dart';
import '../goals/plan_screen.dart';
import '../admin/review_requests_screen.dart';
import '../hubs/hub_detail_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user, required this.profile});

  final User user;
  final Map<String, dynamic> profile;

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: Text(user.isAnonymous
            ? 'You’ll leave guest mode.'
            : 'You can sign back in anytime with your email and password.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Sign out',
                  style: TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok == true) await AuthService.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = user.isAnonymous;
    final name = isGuest
        ? 'Guest'
        : (profile['name'] as String?) ?? user.displayName ?? 'You';
    final interests = List<String>.from(profile['interests'] ?? const []);
    final goals = List<String>.from(profile['goals'] ?? const []);
    final joined = List<String>.from(profile['joinedHubs'] ?? const []);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(
            title: name,
            subtitle: isGuest ? 'Browsing as a guest' : user.email,
            trailing: Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: isGuest
                  ? const Icon(Icons.person_outline_rounded,
                      size: 30, color: AppColors.primary)
                  : Text(_initials(name),
                      style: AppText.heading
                          .copyWith(color: AppColors.primary)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isGuest)
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Make reHUB yours', style: AppText.title),
                        const SizedBox(height: 4),
                        Text(
                          'Create a free account to join hubs, post updates '
                          'and keep a private check-in history.',
                          style: AppText.caption
                              .copyWith(color: AppColors.textMuted),
                        ),
                        const SizedBox(height: 14),
                        AppButton(
                          label: 'Create an account',
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SignUpScreen()),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  CheckInSummary(user: user),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.favorite_border_rounded,
                      title: 'Your interests'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final id in interests)
                        _Chip(
                          label: labelFor(interestOptions, id),
                          icon: interestOptions
                              .firstWhere((o) => o.id == id,
                                  orElse: () => interestOptions.first)
                              .icon,
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.flag_outlined, title: 'Your goals'),
                  const SizedBox(height: 10),
                  _LinkCard(
                    icon: Icons.emoji_events_outlined,
                    title: goals.isEmpty
                        ? 'Set a goal'
                        : goals.map((id) => labelFor(goalOptions, id)).join(' · '),
                    subtitle: 'Milestones, progress and next steps',
                    onTap: () => openGoals(context, user),
                  ),
                  const SizedBox(height: 10),
                  _LinkCard(
                    icon: Icons.shield_outlined,
                    title: 'My plan',
                    subtitle: 'Your private plan for hard moments',
                    onTap: () => openPlan(context, user),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.groups_outlined, title: 'Joined hubs'),
                  const SizedBox(height: 10),
                  _JoinedHubs(user: user, ids: joined),
                  _MyRequests(user: user),
                  _AdminEntry(user: user),
                ],
                const SizedBox(height: 24),

                // Help
                AppCard(
                  color: AppColors.accentTint,
                  bordered: false,
                  onTap: () => showHelpSheet(context),
                  child: Row(
                    children: [
                      const IconTile(
                        icon: Icons.support_outlined,
                        size: 44,
                        color: AppColors.surface,
                        iconColor: AppColors.primaryStrong,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Need to talk to someone?',
                                style: AppText.bodyStrong),
                            Text('Crisis hotlines, free and 24/7',
                                style: AppText.caption
                                    .copyWith(color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textMuted),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () => _confirmSignOut(context),
                  icon: const Icon(Icons.logout_rounded,
                      color: AppColors.danger, size: 20),
                  label: Text(isGuest ? 'Leave guest mode' : 'Sign out',
                      style: AppText.bodyStrong
                          .copyWith(color: AppColors.danger)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title, style: AppText.title),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 7, 14, 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label,
              style: AppText.caption.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _JoinedHubs extends StatelessWidget {
  const _JoinedHubs({required this.user, required this.ids});
  final User user;
  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) {
      return Text(
        'You haven’t joined any hubs yet. Explore hubs from the Home tab.',
        style: AppText.caption.copyWith(color: AppColors.textMuted),
      );
    }
    return StreamBuilder<List<Hub>>(
      stream: HubService.instance.hubs(),
      builder: (context, snap) {
        final hubs =
            (snap.data ?? const <Hub>[]).where((h) => ids.contains(h.id));
        return Column(
          children: [
            for (final hub in hubs)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HubRow(
                  hub: hub,
                  onTap: () => openHub(context, user, hub.id),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Your hub suggestions and their status. Hidden if you have none.
class _MyRequests extends StatelessWidget {
  const _MyRequests({required this.user});
  final User user;

  Future<void> _cancel(BuildContext context, HubRequest r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel “${r.name}”?'),
        content: const Text('Your suggestion will be withdrawn.'),
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
    return StreamBuilder<List<HubRequest>>(
      stream: HubRequestService.instance.myRequests(user.uid),
      builder: (context, snap) {
        final requests = snap.data ?? const <HubRequest>[];
        if (requests.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionTitle(
                  icon: Icons.outbox_outlined, title: 'Your hub suggestions'),
              const SizedBox(height: 10),
              for (final r in requests)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RequestCard(
                    request: r,
                    onTap: r.status == RequestStatus.approved && r.hubId != null
                        ? () => openHub(context, user, r.hubId!)
                        : null,
                    actions: r.status == RequestStatus.pending
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _cancel(context, r),
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
          ),
        );
      },
    );
  }
}

/// Only shown to admins: links to the review queues with counts.
class _AdminEntry extends StatelessWidget {
  const _AdminEntry({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: HubRequestService.instance.isAdmin(user.uid),
      builder: (context, adminSnap) {
        if (adminSnap.data != true) return const SizedBox.shrink();
        return Column(
          children: [
            StreamBuilder<List<HubRequest>>(
              stream: HubRequestService.instance.pending(),
              builder: (context, snap) => _AdminCard(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Review hub requests',
                count: snap.data?.length ?? 0,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ReviewRequestsScreen())),
              ),
            ),
            StreamBuilder<List<Report>>(
              stream: ReportService.instance.open(),
              builder: (context, snap) => _AdminCard(
                icon: Icons.flag_outlined,
                title: 'Review reports',
                count: snap.data?.length ?? 0,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ReviewReportsScreen())),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.icon,
    required this.title,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: AppCard(
        onTap: onTap,
        child: Row(
          children: [
            IconTile(icon: icon, size: 44),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.bodyStrong),
                  Text(
                    count == 0 ? 'Nothing waiting' : '$count waiting for review',
                    style: AppText.caption.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text('$count',
                    style: AppText.label.copyWith(color: Colors.white)),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon: icon, size: 44),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyStrong),
                Text(subtitle,
                    style: AppText.caption.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
