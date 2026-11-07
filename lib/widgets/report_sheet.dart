import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/report.dart';
import '../services/report_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'sheets.dart';

/// Bottom sheet for reporting a post, comment or chat message.
Future<void> showReportSheet(
  BuildContext context, {
  required User user,
  required ReportTarget target,
}) {
  final messenger = ScaffoldMessenger.of(context);
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) => _ReportForm(
      user: user,
      target: target,
      onDone: (message) {
        Navigator.of(sheetContext).pop();
        messenger.showSnackBar(SnackBar(content: Text(message)));
      },
      onHelp: () => showHelpSheet(context),
    ),
  );
}

class _ReportForm extends StatefulWidget {
  const _ReportForm({
    required this.user,
    required this.target,
    required this.onDone,
    required this.onHelp,
  });

  final User user;
  final ReportTarget target;
  final ValueChanged<String> onDone;
  final VoidCallback onHelp;

  @override
  State<_ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<_ReportForm> {
  ReportReason? _reason;
  final _details = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reason = _reason;
    if (reason == null) return;
    setState(() => _sending = true);
    try {
      await ReportService.instance.submit(
        uid: widget.user.uid,
        target: widget.target,
        reason: reason,
        details: _details.text,
      );
      widget.onDone('Thanks for letting us know. An admin will review it.');
    } on AlreadyReported {
      widget.onDone('You’ve already reported this. An admin will review it.');
    } catch (_) {
      if (mounted) setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Couldn’t send the report. Try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text('Report ${widget.target.type.label.toLowerCase()}',
                style: AppText.heading),
            const SizedBox(height: 6),
            Text(
              'Reports are private. The person won’t know who reported them.',
              style: AppText.caption.copyWith(color: AppColors.textMuted),
            ),
            const SizedBox(height: 16),
            for (final r in ReportReason.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: AppCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  color: _reason == r ? AppColors.primaryTint : AppColors.surface,
                  onTap: () => setState(() => _reason = r),
                  child: Row(
                    children: [
                      Icon(r.icon,
                          size: 20,
                          color: _reason == r
                              ? AppColors.primary
                              : AppColors.textMuted),
                      const SizedBox(width: 12),
                      Expanded(child: Text(r.label, style: AppText.bodyStrong)),
                      Icon(
                        _reason == r
                            ? Icons.radio_button_checked_rounded
                            : Icons.radio_button_off_rounded,
                        color: _reason == r
                            ? AppColors.primary
                            : AppColors.textSubtle,
                      ),
                    ],
                  ),
                ),
              ),
            if (_reason == ReportReason.selfHarm)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: AppCard(
                  color: AppColors.accentTint,
                  bordered: false,
                  onTap: widget.onHelp,
                  child: Row(
                    children: [
                      const Icon(Icons.support_outlined,
                          color: AppColors.primaryStrong),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'If someone is in immediate danger, call 911. You '
                          'can also share the free 24/7 NCMH Crisis Hotline '
                          '(1553) with them. Tap for numbers.',
                          style: AppText.caption,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            TextField(
              controller: _details,
              maxLines: 3,
              maxLength: 300,
              textCapitalization: TextCapitalization.sentences,
              style: AppText.body,
              decoration: InputDecoration(
                hintText: 'Anything else we should know? (optional)',
                hintStyle: AppText.body.copyWith(color: AppColors.textSubtle),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.all(14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.border, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Send report',
              loading: _sending,
              onPressed: _reason == null ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
