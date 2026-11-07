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
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        for (final id in goals)
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.check_circle_rounded,
                                color: AppColors.primary, size: 22),
                            title: Text(labelFor(goalOptions, id),
                                style: AppText.bodyStrong),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.groups_outlined, title: 'Joined hubs'),
                  const SizedBox(height: 10),
                  _JoinedHubs(user: user, ids: joined),
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
