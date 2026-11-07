import 'package:flutter/material.dart';

import '../models/hub.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

/// Matches the Figma "Hub Row" component.
class HubRow extends StatelessWidget {
  const HubRow({super.key, required this.hub, this.onTap, this.joined = false});

  final Hub hub;
  final VoidCallback? onTap;
  final bool joined;

  @override
  Widget build(BuildContext context) {
    final meta = AppText.caption.copyWith(color: AppColors.textMuted);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          IconTile(icon: hub.icon, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(hub.name,
                          style: AppText.title,
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (joined) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('Joined',
                            style: AppText.label
                                .copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.people_outline_rounded,
                        size: 15, color: AppColors.textMuted),
                    const SizedBox(width: 5),
                    Text(hub.membersLabel, style: meta),
                    const SizedBox(width: 12),
                    Icon(
                      hub.online
                          ? Icons.public_rounded
                          : Icons.wb_sunny_outlined,
                      size: 15,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Text(hub.modeLabel, style: meta),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textSubtle, size: 22),
        ],
      ),
    );
  }
}
