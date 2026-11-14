import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/avatar.dart';

/// The small public card everyone else sees: just a name and an avatar.
/// Stored at profiles/{uid}. (Everything else on users/{uid} stays private.)
class PublicProfile {
  const PublicProfile({required this.name, this.avatar});
  final String name;
  final AvatarStyle? avatar;
}

/// Looks up people's current name and avatar, so named posts, comments and
/// messages always show the latest ones, even old posts. Each person is
/// fetched once and shared by every widget showing them.
class PublicProfileService {
  PublicProfileService._();
  static final instance = PublicProfileService._();

  final _db = FirebaseFirestore.instance;
  final _streams = <String, Stream<PublicProfile?>>{};
  final _latest = <String, PublicProfile?>{};

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('profiles').doc(uid);

  /// The last known card for [uid] (null if not loaded yet).
  PublicProfile? cached(String uid) => _latest[uid];

  Stream<PublicProfile?> watch(String uid) => _streams.putIfAbsent(uid, () {
        late final StreamController<PublicProfile?> controller;
        StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? sub;
        controller = StreamController<PublicProfile?>.broadcast(
          onListen: () {
            if (_latest.containsKey(uid)) controller.add(_latest[uid]);
            sub ??= _doc(uid).snapshots().listen(
              (d) {
                final data = d.data();
                final name = data?['name'] as String?;
                final card = name == null
                    ? null
                    : PublicProfile(
                        name: name,
                        avatar: AvatarStyle.parse(data?['avatar']),
                      );
                _latest[uid] = card;
                controller.add(card);
              },
              // Not allowed / offline: just keep showing the saved name.
              onError: (_) {},
            );
          },
          onCancel: () async {
            await sub?.cancel();
            sub = null;
          },
        );
        return controller.stream;
      });

  /// Publishes your card. Called when you save your profile, and on app
  /// start so it always matches.
  Future<void> save({
    required String uid,
    required String name,
    required String? avatar,
  }) =>
      _doc(uid).set({
        'name': name.trim(),
        'avatar': avatar,
      });

  Future<void> delete(String uid) => _doc(uid).delete();
}
