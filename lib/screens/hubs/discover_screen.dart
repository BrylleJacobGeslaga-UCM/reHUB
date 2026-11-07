import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../services/hub_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/hub_row.dart';
import '../../widgets/screen_header.dart';
import '../../widgets/sheets.dart';
import 'hub_detail_screen.dart';
import 'request_hub_screen.dart';

enum _Filter { all, online, outdoors }

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key, required this.user, this.joined = const []});

  final User user;
  final List<String> joined;

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  _Filter _filter = _Filter.all;

  List<Hub> _apply(List<Hub> hubs) => switch (_filter) {
        _Filter.all => hubs,
        _Filter.online => hubs.where((h) => h.online).toList(),
        _Filter.outdoors => hubs.where((h) => !h.online).toList(),
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScreenHeader(
              title: 'Discover hubs',
              subtitle: 'Find your people and explore new activities',
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterPill(
                        label: 'All',
                        selected: _filter == _Filter.all,
                        onTap: () => setState(() => _filter = _Filter.all),
                      ),
                      _FilterPill(
                        label: 'Online',
                        icon: Icons.public_rounded,
                        selected: _filter == _Filter.online,
                        onTap: () => setState(() => _filter = _Filter.online),
                      ),
                      _FilterPill(
                        label: 'Outdoors',
                        icon: Icons.wb_sunny_outlined,
                        selected: _filter == _Filter.outdoors,
                        onTap: () =>
                            setState(() => _filter = _Filter.outdoors),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    color: AppColors.primaryTint,
                    bordered: false,
                    onTap: () => widget.user.isAnonymous
                        ? showGuestPrompt(context, action: 'suggest hubs')
                        : openRequestHub(context, widget.user,
                            widget.user.displayName ?? 'Member'),
                    child: Row(
                      children: [
                        const IconTile(
                          icon: Icons.add_rounded,
                          size: 44,
                          color: AppColors.surface,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Don’t see your thing?',
                                  style: AppText.bodyStrong),
                              Text('Suggest a hub. We’ll review it shortly.',
                                  style: AppText.caption
                                      .copyWith(color: AppColors.textMuted)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: AppColors.primary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<Hub>>(
                    stream: HubService.instance.hubs(),
                    builder: (context, snap) {
                      if (snap.hasError) {
                        return const EmptyState(
                          icon: Icons.cloud_off_rounded,
                          title: 'Couldn’t load hubs',
                          message: 'Check your connection and try again.',
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
                      final hubs = _apply(snap.data!);
                      if (hubs.isEmpty) {
                        return const EmptyState(
                          icon: Icons.groups_outlined,
                          title: 'No hubs here yet',
                          message: 'Try another filter.',
                        );
                      }
                      return Column(
                        children: [
                          for (final hub in hubs)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HubRow(
                                hub: hub,
                                joined: widget.joined.contains(hub.id),
                                onTap: () => openHub(context, widget.user, hub.id),
                              ),
                            ),
                        ],
                      );
                    },
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

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = selected ? Colors.white : AppColors.text;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.primary : AppColors.surface,
        shape: StadiumBorder(
          side: selected
              ? BorderSide.none
              : const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: fg),
                  const SizedBox(width: 6),
                ],
                Text(label,
                    style: AppText.caption
                        .copyWith(color: fg, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
