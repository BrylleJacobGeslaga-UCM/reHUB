import 'package:flutter/material.dart';

import '../models/hub_request.dart';
import '../models/onboarding_options.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_card.dart';

/// Small colored label: Pending / Approved / Not approved.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});
  final RequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (String text, Color bg, Color fg) = switch (status) {
      RequestStatus.pending =>
        ('Pending review', AppColors.accentTint, AppColors.text),
      RequestStatus.approved =>
        ('Approved', AppColors.primaryTint, AppColors.primaryStrong),
      RequestStatus.rejected =>
        ('Not approved', AppColors.dangerTint, AppColors.danger),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: AppText.label.copyWith(color: fg)),
    );
  }
}

/// A request summary card used on Profile and the admin review screen.
class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.request,
    this.showRequester = false,
    this.actions,
    this.onTap,
  });

  final HubRequest request;
  final bool showRequester;
  final Widget? actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final icon = interestOptions
        .firstWhere((o) => o.id == request.interest,
            orElse: () => interestOptions.first)
        .icon;
    final meta = AppText.caption.copyWith(color: AppColors.textMuted);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(icon: icon, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name, style: AppText.title),
                    Text(
                      '${labelFor(interestOptions, request.interest)} · '
                      '${request.online ? 'Online' : 'Outdoors'}',
                      style: meta,
                    ),
                  ],
                ),
              ),
              StatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: 10),
          Text(request.description, style: AppText.body),
          if (showRequester) ...[
            const SizedBox(height: 8),
            Text('Suggested by ${request.requesterName}', style: meta),
          ],
          if (request.status == RequestStatus.rejected) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.dangerTint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 18, color: AppColors.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.reviewNote == null ||
                                  request.reviewNote!.isEmpty
                              ? 'This suggestion wasn’t approved.'
                              : 'Why it wasn’t approved',
                          style: AppText.caption.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.w700),
                        ),
                        if (request.reviewNote != null &&
                            request.reviewNote!.isNotEmpty)
                          Text(request.reviewNote!,
                              style: AppText.caption
                                  .copyWith(color: AppColors.text)),
                        const SizedBox(height: 2),
                        Text('You can suggest a new hub anytime.',
                            style: AppText.caption
                                .copyWith(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (actions != null) ...[const SizedBox(height: 12), actions!],
        ],
      ),
    );
  }
}
