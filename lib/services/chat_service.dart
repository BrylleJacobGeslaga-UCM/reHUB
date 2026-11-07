import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

/// Hub group chats.
///
///   hubs/{hubId}/messages/{id}      members only
///   users/{uid}/chatReads/{hubId}   when you last opened that chat
class ChatService {
  ChatService._();
  static final instance = ChatService._();

  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messages(String hubId) =>
      _db.collection('hubs').doc(hubId).collection('messages');

  /// Newest first (the chat list is drawn bottom-up).
  Stream<List<Message>> messages(String hubId) => _messages(hubId)
      .orderBy('createdAt', descending: true)
      .limit(100)
      .snapshots(includeMetadataChanges: true)
      .map((s) => s.docs.map(Message.fromDoc).toList());

  Stream<Message?> latest(String hubId) => _messages(hubId)
      .orderBy('createdAt', descending: true)
      .limit(1)
      .snapshots()
      .map((s) => s.docs.isEmpty ? null : Message.fromDoc(s.docs.first));

  Future<void> send({
    required String hubId,
    required String uid,
    required String name,
    required String body,
  }) {
    return _messages(hubId).add({
      'senderId': uid,
      'senderName': name,
      'body': body.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete({required String hubId, required String messageId}) =>
      _messages(hubId).doc(messageId).delete();

  Stream<Map<String, DateTime>> reads(String uid) => _db
      .collection('users')
      .doc(uid)
      .collection('chatReads')
      .snapshots()
      .map((s) => {
            for (final d in s.docs)
              d.id: (d.data()['at'] as Timestamp?)?.toDate() ?? DateTime.now(),
          });

  Future<void> markRead({required String uid, required String hubId}) => _db
      .collection('users')
      .doc(uid)
      .collection('chatReads')
      .doc(hubId)
      .set({'at': FieldValue.serverTimestamp()});
}
