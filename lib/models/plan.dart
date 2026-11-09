import 'package:cloud_firestore/cloud_firestore.dart';

/// A private plan for hard moments, stored at users/{uid}/private/plan.
/// Only the user can read it.
class RecoveryPlan {
  const RecoveryPlan({
    this.reasons = '',
    this.signs = '',
    this.helps = '',
    this.contactName = '',
    this.contactPhone = '',
  });

  final String reasons;
  final String signs;
  final String helps;
  final String contactName;
  final String contactPhone;

  bool get isEmpty =>
      reasons.isEmpty && signs.isEmpty && helps.isEmpty && contactName.isEmpty;

  factory RecoveryPlan.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? const {};
    String s(String k) => (d[k] as String? ?? '').trim();
    return RecoveryPlan(
      reasons: s('reasons'),
      signs: s('signs'),
      helps: s('helps'),
      contactName: s('contactName'),
      contactPhone: s('contactPhone'),
    );
  }

  Map<String, dynamic> toMap() => {
        'reasons': reasons.trim(),
        'signs': signs.trim(),
        'helps': helps.trim(),
        'contactName': contactName.trim(),
        'contactPhone': contactPhone.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
