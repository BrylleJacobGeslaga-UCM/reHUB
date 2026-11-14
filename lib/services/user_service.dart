import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'public_profile_service.dart';

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

  /// Saves a new name and/or avatar (an [AvatarStyle] code, or null to go
  /// back to initials).
  Future<void> updateProfile({
    required User user,
    required String name,
    required String? avatar,
  }) async {
    await _db.collection('users').doc(user.uid).set({
      'name': name.trim(),
      'avatar': avatar,
    }, SetOptions(merge: true));
    await PublicProfileService.instance
        .save(uid: user.uid, name: name, avatar: avatar);
    // Keep the sign-in account's display name in step (best effort).
    try {
      await user.updateDisplayName(name.trim());
    } catch (_) {}
  }
}
