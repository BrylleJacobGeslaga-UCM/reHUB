import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../models/onboarding_options.dart';
import '../../services/hub_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import '../../widgets/checkin_summary.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import '../admin/admin_screen.dart';
import '../auth/sign_up_screen.dart';
import '../goals/goals_screen.dart';
import '../goals/plan_screen.dart';
import '../hubs/discover_screen.dart';
import '../hubs/hub_detail_screen.dart';
import 'settings_screen.dart';

/// Profile: your progress and your stuff. Rarely-used things live in
/// Settings (gear), and admin tools in the Admin screen (shield).
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
            actions: [
              if (!isGuest) AdminHeaderButton(uid: user.uid),
              HeaderIconButton(
                icon: Icons.settings_outlined,
                tooltip: 'Settings',
                onTap: () => openSettings(context, user),
              ),
            ],
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
                  const SizedBox(height: 14),

                  // Goals + plan in one card
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _CardRow(
                          icon: Icons.emoji_events_outlined,
                          title: 'Your goals',
                          subtitle: goals.isEmpty
                              ? 'Pick a goal to get milestones'
                              : goals
                                  .map((id) => labelFor(goalOptions, id))
                                  .join(' · '),
                          onTap: () => openGoals(context, user),
                        ),
                        const Divider(
                            height: 1, indent: 72, color: AppColors.border),
                        _CardRow(
                          icon: Icons.shield_outlined,
                          title: 'My plan',
                          subtitle: 'Private, for hard moments',
                          onTap: () => openPlan(context, user),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  _SectionTitle(
                      icon: Icons.favorite_border_rounded,
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

                  _SectionTitle(
                      icon: Icons.groups_outlined, title: 'Joined hubs'),
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

class _CardRow extends StatelessWidget {
  const _CardRow({
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

/// Joined hubs as a swipeable row of small tiles.
class _JoinedHubs extends StatelessWidget {
  const _JoinedHubs({required this.user, required this.ids});
  final User user;
  final List<String> ids;

  @override
  Widget build(BuildContext context) {
    if (ids.isEmpty) {
      return AppCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DiscoverScreen(user: user, joined: ids),
        )),
        child: Row(
          children: [
            const IconTile(icon: Icons.explore_outlined, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Text('You haven’t joined any hubs yet. Explore hubs',
                  style: AppText.caption
                      .copyWith(color: AppColors.textMuted)),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textMuted),
          ],
        ),
      );
    }
    return StreamBuilder<List<Hub>>(
      stream: HubService.instance.hubs(),
      builder: (context, snap) {
        final hubs = (snap.data ?? const <Hub>[])
            .where((h) => ids.contains(h.id))
            .toList();
        return SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: hubs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, i) {
              final hub = hubs[i];
              return SizedBox(
                width: 112,
                child: AppCard(
                  onTap: () => openHub(context, user, hub.id),
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                  child: Column(
                    children: [
                      IconTile(icon: hub.icon, size: 44),
                      const SizedBox(height: 8),
                      Text(
                        hub.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.caption.copyWith(
                            color: AppColors.text,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
