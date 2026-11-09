import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';

void openGuidelines(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const GuidelinesScreen()),
  );
}

class _Point {
  const _Point(this.icon, this.title, this.text);
  final IconData icon;
  final String title;
  final String text;
}

const _guidelines = [
  _Point(Icons.favorite_border_rounded, 'Be kind',
      'Everyone here is working on something hard. Encourage, don’t judge. '
      'No insults, bullying, harassment or hate.'),
  _Point(Icons.block_rounded, 'Keep it substance-free',
      'Don’t encourage use, share where to get substances, or buy or sell '
      'anything. This gets you removed right away.'),
  _Point(Icons.place_outlined, 'Meet safely',
      'Meetups happen in public places only. Tell someone where you’re going, '
      'and never feel pressured to share more than you want to.'),
  _Point(Icons.lock_outline_rounded, 'Respect privacy',
      'What’s shared in a hub stays in the hub. Don’t screenshot or share '
      'other people’s posts, and never try to find out who posted anonymously.'),
  _Point(Icons.flag_outlined, 'Report, don’t fight',
      'If something isn’t right, use Report. Admins review every report, and '
      'the person won’t know who reported them.'),
  _Point(Icons.support_outlined, 'Peer support, not treatment',
      'reHUB is a community, not a replacement for doctors, counselors or '
      'treatment programs. In a crisis, call the NCMH Crisis Hotline (1553) '
      'or 911.'),
];

const _privacy = [
  _Point(Icons.person_outline_rounded, 'Your account',
      'Your name and email, used to sign in. Your email is never shown to '
      'other members.'),
  _Point(Icons.visibility_off_outlined, 'Only you can see',
      'Your daily check-ins, notes, My plan, and the posts and reactions '
      'tied to you.'),
  _Point(Icons.groups_outlined, 'Your hubs can see',
      'Posts, comments, chat messages and activities, but only members of '
      'that hub. Anonymous posts don’t store who wrote them.'),
  _Point(Icons.admin_panel_settings_outlined, 'Admins can see',
      'Content that’s been reported, so they can keep reHUB safe.'),
  _Point(Icons.delete_outline_rounded, 'You’re in control',
      'You can delete your account anytime in Settings. Your check-ins, plan, '
      'posts, comments and messages are deleted with it.'),
];

/// Community guidelines + a plain-language privacy summary.
class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  Widget _section(String title, List<_Point> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppText.heading),
        const SizedBox(height: 12),
        for (final p in points)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTile(icon: p.icon, size: 40),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.title, style: AppText.bodyStrong),
                        const SizedBox(height: 2),
                        Text(p.text,
                            style: AppText.caption
                                .copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Guidelines',
              subtitle: 'How we keep reHUB safe and kind',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _section('Community guidelines', _guidelines),
                  const SizedBox(height: 16),
                  _section('Your privacy', _privacy),
                  const SizedBox(height: 8),
                  AppCard(
                    color: AppColors.accentTint,
                    bordered: false,
                    onTap: () => showHelpSheet(context),
                    child: Row(
                      children: [
                        const Icon(Icons.support_outlined,
                            color: AppColors.primaryStrong),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Need to talk to someone? Tap for free, 24/7 '
                            'crisis hotlines.',
                            style: AppText.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
