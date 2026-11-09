import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// All sign-in / sign-up logic lives here so screens stay simple.
class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Lets us push an update after checking email verification
  /// (Firebase doesn't announce that change by itself).
  final _manual = StreamController<User?>.broadcast();

  /// Emits whenever the user signs in/out, their profile changes, or their
  /// email gets verified.
  late final Stream<User?> userChanges = _merged();

  Stream<User?> _merged() {
    StreamSubscription<User?>? a;
    StreamSubscription<User?>? b;
    late final StreamController<User?> controller;
    controller = StreamController<User?>.broadcast(
      onListen: () {
        a = _auth.userChanges().listen(controller.add,
            onError: controller.addError);
        b = _manual.stream.listen(controller.add);
      },
      onCancel: () async {
        await a?.cancel();
        await b?.cancel();
      },
    );
    return controller.stream;
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signIn(String email, String password) =>
      _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final current = _auth.currentUser;
    final UserCredential cred;
    if (current != null && current.isAnonymous) {
      // Upgrade the guest session into a real account (same user ID).
      cred = await current.linkWithCredential(
        EmailAuthProvider.credential(email: email.trim(), password: password),
      );
    } else {
      cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
    }
    final user = cred.user!;
    await user.updateDisplayName(name.trim());
    await _db.collection('users').doc(user.uid).set({
      'name': name.trim(),
      'email': email.trim(),
      'onboarded': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await user.sendEmailVerification();
  }

  /// Re-checks whether the email link was clicked. Returns true if verified.
  Future<bool> refreshVerification() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    await user.reload();
    final fresh = _auth.currentUser;
    final verified = fresh?.emailVerified ?? false;
    if (verified) {
      // Get a new sign-in token so the database rules see "verified".
      await fresh!.getIdToken(true);
      _manual.add(fresh);
    }
    return verified;
  }

  Future<void> resendVerification() async =>
      _auth.currentUser?.sendEmailVerification();

  /// Deletes an account that was never verified (e.g. a typo in the email),
  /// so the person can sign up again with the right address.
  Future<void> deleteUnverifiedAccount() async {
    final user = _auth.currentUser;
    if (user == null || user.emailVerified) return;
    try {
      await _db.collection('users').doc(user.uid).delete();
      await user.delete();
    } catch (_) {
      // e.g. "requires recent login": just sign out instead.
      await _auth.signOut();
    }
  }

  Future<void> continueAsGuest() => _auth.signInAnonymously();

  Future<void> sendPasswordReset(String email) =>
      _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> signOut() => _auth.signOut();

  /// Turns Firebase error codes into friendly messages.
  static String messageFor(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'Email or password is incorrect.';
        case 'invalid-email':
          return 'That email address doesn’t look right.';
        case 'email-already-in-use':
        case 'credential-already-in-use':
          return 'An account with this email already exists. Try signing in.';
        case 'weak-password':
          return 'Please choose a stronger password (at least 8 characters).';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'No internet connection. Check your network and try again.';
        case 'operation-not-allowed':
          return 'This sign-in method isn’t enabled in Firebase yet.';
      }
      return error.message ?? 'Something went wrong. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
