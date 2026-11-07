import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/hub.dart';
import '../../services/hub_request_service.dart';
import '../../services/hub_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// Admins only, and only for hubs that came from member suggestions.
/// The 8 starter hubs can't be deleted.
class DeleteHubButton extends StatelessWidget {
  const DeleteHubButton({super.key, required this.user, required this.hub});

  final User user;
  final Hub hub;

  @override
  Widget build(BuildContext context) {
    if (user.isAnonymous || hub.isStarter) return const SizedBox.shrink();

    return StreamBuilder<bool>(
      stream: HubRequestService.instance.isAdmin(user.uid),
      builder: (context, snap) {
        if (snap.data != true) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: TextButton.icon(
              onPressed: () => _confirm(context),
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppColors.danger, size: 20),
              label: Text('Delete this hub',
                  style:
                      AppText.bodyStrong.copyWith(color: AppColors.danger)),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmDialog(hub: hub),
    );
    if (ok != true) return;

    // Leave the hub page first, then clean up in the background.
    navigator.pop();
    messenger.showSnackBar(
        SnackBar(content: Text('Deleting ${hub.name}…')));
    try {
      await HubService.instance.deleteHub(hub.id);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${hub.name} was deleted.')));
    } catch (_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('Couldn’t finish deleting the hub. Try again.')));
    }
  }
}

class _ConfirmDialog extends StatefulWidget {
  const _ConfirmDialog({required this.hub});
  final Hub hub;

  @override
  State<_ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<_ConfirmDialog> {
  final _typed = TextEditingController();

  @override
  void initState() {
    super.initState();
    _typed.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _typed.text.trim().toUpperCase() == 'DELETE';
    return AlertDialog(
      title: Text('Delete ${widget.hub.name}?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This permanently deletes the hub, its posts and comments, '
            'chat messages and activities, and removes all '
            '${widget.hub.membersLabel}. This can’t be undone.',
            style: AppText.body,
          ),
          const SizedBox(height: 14),
          Text('Type DELETE to confirm',
              style: AppText.caption.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          TextField(
            controller: _typed,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(hintText: 'DELETE'),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        TextButton(
          onPressed: ready ? () => Navigator.pop(context, true) : null,
          child: Text('Delete hub',
              style: TextStyle(
                  color: ready ? AppColors.danger : AppColors.textSubtle)),
        ),
      ],
    );
  }
}
