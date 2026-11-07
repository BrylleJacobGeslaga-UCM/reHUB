import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hub.dart';
import '../models/post.dart';

/// Feed posts, reactions and comments.
///
///   posts/{postId}                        the public post (no author id)
///   posts/{postId}/comments/{commentId}   public replies (no author id)
///   users/{uid}/posts/{postId}            private: "I wrote this post"
///   users/{uid}/comments/{commentId}      private: "I wrote this comment"
///   users/{uid}/reactions/{postId}        private: my reaction to a post
class PostService {
  PostService._();
  static final instance = PostService._();

  final _db = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _posts =>
      _db.collection('posts');
  DocumentReference<Map<String, dynamic>> _user(String uid) =>
      _db.collection('users').doc(uid);

  // ---------- posts ----------

  /// Newest posts from the given hubs, merged into one list.
  ///
  /// Posts are private to each hub, so we ask per hub ("posts where
  /// hubId == X") — that's a query the security rules can check.
  Stream<List<Post>> feed(List<String> hubIds) {
    if (hubIds.isEmpty) return Stream.value(const []);

    final latest = <String, List<Post>>{};
    final subs = <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];
    late final StreamController<List<Post>> controller;

    void emit() {
      if (latest.length < hubIds.length) return; // wait for every hub once
      final all = latest.values.expand((l) => l).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      controller.add(all);
    }

    controller = StreamController<List<Post>>(
      onListen: () {
        for (final id in hubIds) {
          subs.add(_posts
              .where('hubId', isEqualTo: id)
              .orderBy('createdAt', descending: true)
              .limit(50)
              .snapshots()
              .listen(
            (snap) {
              latest[id] = snap.docs.map(Post.fromDoc).toList();
              emit();
            },
            onError: (Object e) {
              // A missing index is a setup problem worth showing.
              if (e is FirebaseException && e.code == 'failed-precondition') {
                controller.addError(e);
              }
              latest[id] = const [];
              emit();
            },
          ));
        }
      },
      onCancel: () async {
        for (final sub in subs) {
          await sub.cancel();
        }
      },
    );
    return controller.stream;
  }

  Stream<Post?> post(String postId) => _posts
      .doc(postId)
      .snapshots()
      .map((d) => d.exists ? Post.fromDoc(d) : null);

  Stream<Set<String>> myPostIds(String uid) => _user(uid)
      .collection('posts')
      .snapshots()
      .map((s) => s.docs.map((d) => d.id).toSet());

  Future<void> create({
    required String uid,
    required Hub hub,
    required String body,
    required bool anonymous,
    required String authorName,
  }) {
    final postRef = _posts.doc();
    final batch = _db.batch();
    batch.set(postRef, {
      'hubId': hub.id,
      'hubName': hub.name,
      'authorName': anonymous ? null : authorName,
      'anonymous': anonymous,
      'body': body.trim(),
      'createdAt': FieldValue.serverTimestamp(),
      'reactions': {for (final r in Reaction.values) r.name: 0},
      'commentCount': 0,
    });
    batch.set(_user(uid).collection('posts').doc(postRef.id), {
      'hubId': hub.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return batch.commit();
  }

  Future<void> delete({required String uid, required String postId}) {
    final batch = _db.batch();
    batch.delete(_posts.doc(postId));
    batch.delete(_user(uid).collection('posts').doc(postId));
    batch.delete(_user(uid).collection('reactions').doc(postId));
    return batch.commit();
  }

  // ---------- reactions ----------

  Stream<Map<String, Reaction>> myReactions(String uid) => _user(uid)
      .collection('reactions')
      .snapshots()
      .map((s) => {
            for (final d in s.docs)
              if (reactionFromName(d.data()['type'] as String?) != null)
                d.id: reactionFromName(d.data()['type'] as String?)!,
          });

  /// One reaction per person per post. Tapping the same one again removes
  /// it; tapping a different one switches.
  Future<void> react({
    required String uid,
    required String postId,
    required Reaction reaction,
  }) {
    final postRef = _posts.doc(postId);
    final mineRef = _user(uid).collection('reactions').doc(postId);

    return _db.runTransaction((tx) async {
      final post = await tx.get(postRef);
      if (!post.exists) return;
      final mine = await tx.get(mineRef);
      final old = reactionFromName(mine.data()?['type'] as String?);

      final updates = <String, dynamic>{};
      if (old == reaction) {
        tx.delete(mineRef);
        updates['reactions.${reaction.name}'] = FieldValue.increment(-1);
      } else {
        tx.set(mineRef, {
          'type': reaction.name,
          'at': FieldValue.serverTimestamp(),
        });
        updates['reactions.${reaction.name}'] = FieldValue.increment(1);
        if (old != null) {
          updates['reactions.${old.name}'] = FieldValue.increment(-1);
        }
      }
      tx.update(postRef, updates);
    });
  }

  // ---------- comments ----------

  Stream<List<Comment>> comments(String postId) => _posts
      .doc(postId)
      .collection('comments')
      .orderBy('createdAt')
      .limit(200)
      .snapshots()
      .map((s) => s.docs.map(Comment.fromDoc).toList());

  Stream<Set<String>> myCommentIds(String uid) => _user(uid)
      .collection('comments')
      .snapshots()
      .map((s) => s.docs.map((d) => d.id).toSet());

  Future<void> addComment({
    required String uid,
    required String postId,
    required String body,
    required bool anonymous,
    required String authorName,
  }) {
    final postRef = _posts.doc(postId);
    final commentRef = postRef.collection('comments').doc();
    final batch = _db.batch();
    batch.set(commentRef, {
      'authorName': anonymous ? null : authorName,
      'anonymous': anonymous,
      'body': body.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.set(_user(uid).collection('comments').doc(commentRef.id), {
      'postId': postId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(postRef, {'commentCount': FieldValue.increment(1)});
    return batch.commit();
  }

  Future<void> deleteComment({
    required String uid,
    required String postId,
    required String commentId,
  }) {
    final postRef = _posts.doc(postId);
    final batch = _db.batch();
    batch.delete(postRef.collection('comments').doc(commentId));
    batch.delete(_user(uid).collection('comments').doc(commentId));
    batch.update(postRef, {'commentCount': FieldValue.increment(-1)});
    return batch.commit();
  }
}
