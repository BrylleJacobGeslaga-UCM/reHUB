import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import '../auth/sign_up_screen.dart';
import '../hubs/my_requests_screen.dart';
import '../info/guidelines_screen.dart';
import '../../services/reminder_service.dart';
import 'blocked_screen.dart';
import 'reminder_row.dart';
import 'delete_account_screen.dart';

void openSettings(BuildContext context, User user) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => SettingsScreen(user: user),
  ));
}

/// Things you rarely need: account, support, and signing out.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.user});

  final User user;

  Future<void> _signOut(BuildContext context) async {
    final guest = user.isAnonymous;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(guest ? 'Leave guest mode?' : 'Sign out?'),
        content: Text(guest
            ? 'You can come back anytime.'
            : 'You can sign back in anytime with your email and password.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(guest ? 'Leave' : 'Sign out',
                  style: const TextStyle(color: AppColors.danger))),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
    // Reminders belong to this account; stop them on this phone.
    await ReminderService.instance.cancel().catchError((_) {});
    await AuthService.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final guest = user.isAnonymous;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Settings',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _Label('Account'),
                  _Group(children: [
                    _Row(
                      icon: Icons.mail_outline_rounded,
                      title: guest ? 'Guest' : (user.email ?? 'Your account'),
                      subtitle: guest
                          ? 'Browsing without an account'
                          : 'Signed in with email',
                    ),
                    if (guest)
                      _Row(
                        icon: Icons.person_add_alt_1_outlined,
                        title: 'Create an account',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()),
                        ),
                      )
                    else
                      _Row(
                        icon: Icons.outbox_outlined,
                        title: 'Your hub suggestions',
                        onTap: () => openMyRequests(context, user),
                      ),
                    if (!guest)
                      _Row(
                        icon: Icons.block_outlined,
                        title: 'Blocked members',
                        onTap: () => openBlocked(context, user),
                      ),
                  ]),
                  if (!guest) ...[
                    const SizedBox(height: 20),
                    const _Label('Reminders'),
                    _Group(children: [ReminderRow(user: user)]),
                  ],
                  const SizedBox(height: 20),
                  const _Label('Support'),
                  _Group(children: [
                    _Row(
                      icon: Icons.support_outlined,
                      title: 'Need to talk to someone?',
                      subtitle: 'Crisis hotlines, free and 24/7',
                      onTap: () => showHelpSheet(context),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  const _Label('About'),
                  _Group(children: [
                    _Row(
                      icon: Icons.menu_book_outlined,
                      title: 'Guidelines & privacy',
                      subtitle: 'How we keep reHUB safe, and what we store',
                      onTap: () => openGuidelines(context),
                    ),
                    const _Row(
                      icon: Icons.info_outline_rounded,
                      title: 'reHUB',
                      subtitle: 'A peer-support community, not a substitute '
                          'for professional care.',
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _Group(children: [
                    _Row(
                      icon: Icons.logout_rounded,
                      title: guest ? 'Leave guest mode' : 'Sign out',
                      danger: true,
                      onTap: () => _signOut(context),
                    ),
                    if (!guest)
                      _Row(
                        icon: Icons.delete_forever_outlined,
                        title: 'Delete account',
                        danger: true,
                        onTap: () => openDeleteAccount(context),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(text.toUpperCase(),
          style: AppText.label.copyWith(color: AppColors.textMuted)),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, indent: 58, color: AppColors.border),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.bodyStrong.copyWith(
                          color: danger ? AppColors.danger : AppColors.text)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppText.caption
                            .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            if (onTap != null && !danger)
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textSubtle),
          ],
        ),
      ),
    );
  }
}
