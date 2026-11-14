import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import 'guidelines_screen.dart';

void openAbout(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const AboutScreen()),
  );
}

const _releasesUrl = 'https://github.com/BrylleJacobGeslaga-UCM/reHUB/releases';

class _Link {
  const _Link(this.icon, this.label, this.handle, this.url);
  final IconData icon;
  final String label;
  final String handle;
  final String url;
}

const _links = [
  _Link(Icons.facebook, 'Facebook', 'Brylle Jacob Geslaga',
      'https://web.facebook.com/bryllejacob.geslaga.1'),
  _Link(Icons.code_rounded, 'GitHub', 'BrylleJacobGeslaga-UCM',
      'https://github.com/BrylleJacobGeslaga-UCM'),
  _Link(Icons.photo_camera_outlined, 'Instagram', '@broyleee',
      'https://www.instagram.com/broyleee/'),
];

/// About reHUB: what it is, how privacy works, and who made it.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(BuildContext context, String url) async {
    final ok = await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Couldn’t open the link.')));
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
              title: 'About reHUB',
              subtitle: 'Rebuild with support, one day at a time',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---- app card ----
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: SvgPicture.asset('assets/logo_white.svg'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('reHUB', style: AppText.heading),
                              const SizedBox(height: 2),
                              const _Version(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ---- why ----
                  Text('Why reHUB', style: AppText.title),
                  const SizedBox(height: 8),
                  Text(
                    'Recovery is easier when you’re not doing it alone. '
                    'reHUB connects people who are rebuilding their lives '
                    'through the things they love, like riding, gaming, music '
                    'or books, so the hours that used to feel empty can be '
                    'filled with people who get it.',
                    style: AppText.body.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Join a hub, check in with yourself each day, share how '
                    'you’re doing (with your name or anonymously), and show up '
                    'for each other.',
                    style: AppText.body.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 24),

                  // ---- privacy ----
                  Text('Your privacy, simply', style: AppText.title),
                  const SizedBox(height: 10),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const _Point(
                          icon: Icons.shield_outlined,
                          title: 'Anonymous means anonymous',
                          text: 'Anonymous posts and comments don’t store who '
                              'wrote them. Not even admins can tell.',
                        ),
                        const Divider(
                            height: 1, indent: 70, color: AppColors.border),
                        const _Point(
                          icon: Icons.lock_outline_rounded,
                          title: 'Your check-ins are yours',
                          text: 'Daily check-ins and My plan are private. '
                              'Only you can see them.',
                        ),
                        const Divider(
                            height: 1, indent: 70, color: AppColors.border),
                        const _Point(
                          icon: Icons.groups_outlined,
                          title: 'Hubs stay in the hub',
                          text: 'Posts, chats and activities are only visible '
                              'to members of that hub.',
                        ),
                        const Divider(
                            height: 1, indent: 70, color: AppColors.border),
                        _LinkRow(
                          icon: Icons.menu_book_outlined,
                          title: 'Read the full guidelines & privacy',
                          onTap: () => openGuidelines(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ---- not treatment ----
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
                              Text('Peer support, not treatment',
                                  style: AppText.bodyStrong),
                              Text(
                                'reHUB doesn’t replace doctors or counselors. '
                                'Need help now? Tap for crisis hotlines.',
                                style: AppText.caption
                                    .copyWith(color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.textMuted),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ---- maker ----
                  Text('Made by', style: AppText.title),
                  const SizedBox(height: 10),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentTint,
                                  shape: BoxShape.circle,
                                ),
                                child: Text('BG',
                                    style: AppText.bodyStrong.copyWith(
                                        fontWeight: FontWeight.w800)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Brylle Jacob Geslaga',
                                        style: AppText.bodyStrong),
                                    Text(
                                      'BSIT student, University of Cebu – '
                                      'Main Campus',
                                      style: AppText.caption.copyWith(
                                          color: AppColors.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        for (final l in _links) ...[
                          const Divider(
                              height: 1, indent: 70, color: AppColors.border),
                          _LinkRow(
                            icon: l.icon,
                            title: l.label,
                            subtitle: l.handle,
                            external: true,
                            onTap: () => _open(context, l.url),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: _LinkRow(
                      icon: Icons.system_update_outlined,
                      title: 'Updates & downloads',
                      subtitle: 'Get the newest version on GitHub',
                      external: true,
                      onTap: () => _open(context, _releasesUrl),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Made with care in Cebu, Philippines.',
                    textAlign: TextAlign.center,
                    style: AppText.caption.copyWith(color: AppColors.textSubtle),
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

/// "Version 1.2.0 (5)", read from the app itself.
class _Version extends StatelessWidget {
  const _Version();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final info = snap.data;
        return Text(
          info == null
              ? 'Version …'
              : 'Version ${info.version} (${info.buildNumber})',
          style: AppText.caption.copyWith(color: AppColors.textMuted),
        );
      },
    );
  }
}

class _Point extends StatelessWidget {
  const _Point({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon: icon, size: 40),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.bodyStrong),
                const SizedBox(height: 2),
                Text(text,
                    style:
                        AppText.caption.copyWith(color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.external = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool external;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        child: Row(
          children: [
            IconTile(icon: icon, size: 40),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.bodyStrong),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppText.caption
                            .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(
              external
                  ? Icons.open_in_new_rounded
                  : Icons.chevron_right_rounded,
              size: external ? 18 : 24,
              color: AppColors.textSubtle,
            ),
          ],
        ),
      ),
    );
  }
}
