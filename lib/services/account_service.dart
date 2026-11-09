import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/post.dart';
import 'hub_service.dart';
import 'reminder_service.dart';

/// Permanently deleting an account and the user's data.
class AccountService {
  AccountService._();
  static final instance = AccountService._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Confirms the password, then deletes everything.
  /// [onStep] gets short progress messages for the UI.
  Future<void> deleteAccount({
    required String password,
    required void Function(String step) onStep,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;

    // 1. Firebase requires a recent sign-in to delete an account.
    onStep('Checking your password…');
    await user.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: user.email!, password: password),
    );

    final uid = user.uid;
    final me = _db.collection('users').doc(uid);
    final profile = (await me.get()).data() ?? const {};
    final joined = List<String>.from(profile['joinedHubs'] ?? const []);

    // Each cleanup step is best-effort: one failure shouldn't stop the rest.
    Future<void> tryIt(Future<void> Function() f) async {
      try {
        await f();
      } catch (_) {}
    }

    // 2. Comments, reactions and RSVPs (while still a member of the hubs,
    //    so counts can be updated).
    onStep('Removing your comments and reactions…');
    for (final c in (await me.collection('comments').get()).docs) {
      final postId = c.data()['postId'] as String?;
      if (postId != null) {
        final post = _db.collection('posts').doc(postId);
        // Delete the comment itself first (always allowed for the author),
        // then fix the count if the post is still reachable.
        await tryIt(() async {
          final batch = _db.batch();
          batch.delete(post.collection('comments').doc(c.id));
          batch.delete(c.reference);
          await batch.commit();
        });
        await tryIt(() =>
            post.update({'commentCount': FieldValue.increment(-1)}));
      }
      await tryIt(() => c.reference.delete());
    }
    for (final r in (await me.collection('reactions').get()).docs) {
      final type = reactionFromName(r.data()['type'] as String?);
      await tryIt(() async {
        final batch = _db.batch();
        if (type != null) {
          batch.update(_db.collection('posts').doc(r.id),
              {'reactions.${type.name}': FieldValue.increment(-1)});
        }
        batch.delete(r.reference);
        await batch.commit();
      });
      await tryIt(() => r.reference.delete());
    }
    for (final r in (await me.collection('rsvps').get()).docs) {
      final hubId = r.data()['hubId'] as String?;
      await tryIt(() async {
        if (hubId == null) return;
        final event =
            _db.collection('hubs').doc(hubId).collection('events').doc(r.id);
        final batch = _db.batch();
        batch.delete(event.collection('going').doc(uid));
        batch.update(event, {'goingCount': FieldValue.increment(-1)});
        batch.delete(r.reference);
        await batch.commit();
      });
      await tryIt(() => r.reference.delete());
    }

    // 3. Posts (anonymous ones too) and chat messages.
    onStep('Removing your posts and messages…');
    for (final p in (await me.collection('posts').get()).docs) {
      await tryIt(() async {
        final batch = _db.batch();
        batch.delete(_db.collection('posts').doc(p.id));
        batch.delete(p.reference);
        await batch.commit();
      });
      await tryIt(() => p.reference.delete());
    }
    for (final hubId in joined) {
      await tryIt(() async {
        final mine = await _db
            .collection('hubs')
            .doc(hubId)
            .collection('messages')
            .where('senderId', isEqualTo: uid)
            .get();
        for (final m in mine.docs) {
          await tryIt(() => m.reference.delete());
        }
      });
    }

    // 4. Leave every hub (leaders step down automatically).
    onStep('Leaving your hubs…');
    for (final hubId in joined) {
      await tryIt(() => HubService.instance.leave(user: user, hubId: hubId));
    }

    // 5. Pending hub suggestions.
    await tryIt(() async {
      final pending = await _db
          .collection('hubRequests')
          .where('requestedBy', isEqualTo: uid)
          .get();
      for (final r in pending.docs) {
        if (r.data()['status'] == 'pending') {
          await tryIt(() => r.reference.delete());
        }
      }
    });

    // 6. Private data: check-ins, plan, read markers, then the profile.
    onStep('Removing your check-ins and profile…');
    for (final sub in ['checkins', 'private', 'chatReads', 'posts',
        'comments', 'reactions', 'rsvps']) {
      final docs = (await me.collection(sub).get()).docs;
      for (final d in docs) {
        await tryIt(() => d.reference.delete());
      }
    }
    await tryIt(() => me.delete());

    await tryIt(() => ReminderService.instance.cancel());

    // 7. Finally, the sign-in account itself.
    onStep('Deleting your account…');
    await user.delete();
  }
}
