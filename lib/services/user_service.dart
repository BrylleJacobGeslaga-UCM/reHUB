import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Reads and writes the user's profile document: users/{uid}.
class UserService {
  UserService._();
  static final instance = UserService._();

  final _db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> userDoc(String uid) =>
      _db.collection('users').doc(uid).snapshots();

  Future<void> completeOnboarding({
    required User user,
    required List<String> interests,
    required List<String> goals,
  }) {
    return _db.collection('users').doc(user.uid).set({
      'interests': interests,
      'goals': goals,
      'onboarded': true,
      'onboardedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
