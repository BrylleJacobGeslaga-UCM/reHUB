import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../services/hub_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/hub_row.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/checkin_card.dart';
import '../hubs/discover_screen.dart';
import '../hubs/hub_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.profile,
    required this.onGoTo,
  });

  final User user;
  final Map<String, dynamic> profile;

  /// Switches the bottom-nav tab (0 Home, 1 Feed, 2 Chat, 3 Profile).
  final ValueChanged<int> onGoTo;

  static const _days = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];

  String _greeting(DateTime now) {
    if (now.hour < 12) return 'Good morning';
    if (now.hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  String _firstName() {
    if (user.isAnonymous) return '';
    final name = (profile['name'] as String?) ?? user.displayName ?? '';
    return name.trim().split(' ').first;
  }

  void _discover(BuildContext context, List<String> joined) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => DiscoverScreen(user: user, joined: joined),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final first = _firstName();
    final interests = List<String>.from(profile['interests'] ?? const []);
    final joined = List<String>.from(profile['joinedHubs'] ?? const []);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(
            title: first.isEmpty ? _greeting(now) : '${_greeting(now)}, $first',
            subtitle:
                '${_days[now.weekday - 1]}, ${_months[now.month - 1]} ${now.day}',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Daily check-in
                CheckInCard(user: user),
                const SizedBox(height: 16),

                // Quick actions
                Row(
                  children: [
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.explore_outlined,
                        title: 'Explore hubs',
                        subtitle: 'Find your people',
                        onTap: () => _discover(context, joined),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAction(
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Open chat',
                        subtitle: 'Talk with your hubs',
                        onTap: () => onGoTo(2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Hubs (live from Firestore)
                StreamBuilder<List<Hub>>(
                  stream: HubService.instance.hubs(),
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
                    final all = snap.data!;
                    final mine =
                        all.where((h) => joined.contains(h.id)).toList();
                    final others =
                        all.where((h) => !joined.contains(h.id)).toList()
                          ..sort((a, b) {
                            final am = interests.contains(a.interest) ? 0 : 1;
                            final bm = interests.contains(b.interest) ? 0 : 1;
                            return am.compareTo(bm);
                          });
                    final suggested = others.take(3).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (mine.isNotEmpty) ...[
                          _SectionHeader(title: 'Your hubs'),
                          for (final hub in mine)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HubRow(
                                hub: hub,
                                onTap: () => openHub(context, user, hub.id),
                              ),
                            ),
                          const SizedBox(height: 12),
                        ],
                        if (suggested.isNotEmpty) ...[
                          _SectionHeader(
                            title: interests.isEmpty
                                ? 'Popular hubs'
                                : 'Suggested for you',
                            action: 'See all',
                            onAction: () => _discover(context, joined),
                          ),
                          for (final hub in suggested)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HubRow(
                                hub: hub,
                                onTap: () => openHub(context, user, hub.id),
                              ),
                            ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppText.title),
          if (action != null)
            TextButton(
              onPressed: onAction,
              child: Text(action!,
                  style: AppText.caption.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon: icon, size: 40),
          const SizedBox(height: 10),
          Text(title, style: AppText.bodyStrong),
          Text(subtitle,
              style: AppText.caption.copyWith(color: AppColors.textMuted)),
        ],
      ),
    );
  }
}
