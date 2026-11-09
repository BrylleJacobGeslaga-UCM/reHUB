import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Members you've blocked, stored privately at users/{uid}/blocked/{id}.
/// Blocking hides their named posts, comments and chat messages from you.
class BlockService {
  BlockService._();
  static final instance = BlockService._();

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('blocked');

  /// Blocked user id → their name (as shown when you blocked them).
  Stream<Map<String, String>> blocked(String uid) => _col(uid)
      .snapshots()
      .map((s) => {
            for (final d in s.docs) d.id: d.data()['name'] as String? ?? 'Member',
          });

  Future<void> block(String uid, String targetId, String name) =>
      _col(uid).doc(targetId).set({
        'name': name,
        'at': FieldValue.serverTimestamp(),
      });

  Future<void> unblock(String uid, String targetId) =>
      _col(uid).doc(targetId).delete();
}

/// Asks "Block [name]?" and blocks on confirm.
Future<void> confirmBlock(
  BuildContext context, {
  required String uid,
  required String targetId,
  required String name,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Block $name?'),
      content: Text(
          'You won’t see $name’s posts, comments or chat messages anymore. '
          'They won’t be told. You can unblock them anytime in Settings.\n\n'
          'If they’re harassing you, please report them too.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Block',
                style: TextStyle(color: AppColors.danger))),
      ],
    ),
  );
  if (ok != true) return;
  try {
    await BlockService.instance.block(uid, targetId, name);
    messenger.showSnackBar(SnackBar(content: Text('$name is blocked.')));
  } catch (_) {
    messenger.showSnackBar(
        const SnackBar(content: Text('Couldn’t block. Try again.')));
  }
}
