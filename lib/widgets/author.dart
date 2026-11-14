import 'package:flutter/material.dart';

import '../models/avatar.dart';
import '../services/public_profile_service.dart';

/// Shows someone's *current* name and avatar (from their public card).
/// Falls back to what was saved on the post/comment/message while loading,
/// or when there's no [uid] (anonymous posts never have one).
class AuthorBuilder extends StatelessWidget {
  const AuthorBuilder({
    super.key,
    required this.uid,
    required this.name,
    required this.avatar,
    required this.builder,
  });

  final String? uid;
  final String name;
  final AvatarStyle? avatar;
  final Widget Function(BuildContext context, String name, AvatarStyle? avatar)
      builder;

  @override
  Widget build(BuildContext context) {
    final id = uid;
    if (id == null || id.isEmpty) return builder(context, name, avatar);
    final service = PublicProfileService.instance;
    return StreamBuilder<PublicProfile?>(
      stream: service.watch(id),
      initialData: service.cached(id),
      builder: (context, snap) {
        final card = snap.data;
        if (card == null) return builder(context, name, avatar);
        return builder(context, card.name, card.avatar);
      },
    );
  }
}
