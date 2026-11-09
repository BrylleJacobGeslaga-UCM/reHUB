/// Temporary / throwaway email services. Sign-ups from these are refused,
/// here and in firestore.rules (keep both lists in sync).
const blockedEmailDomains = <String>{
  '10minutemail.com', '10minutemail.net', '1secmail.com', '1secmail.net',
  'burnermail.io', 'discard.email', 'dispostable.com', 'emailfake.com',
  'emailondeck.com', 'fakeinbox.com', 'getnada.com', 'grr.la',
  'guerrillamail.com', 'guerrillamail.net', 'guerrillamail.org',
  'inboxkitten.com', 'mail.tm', 'mailcatch.com', 'maildrop.cc',
  'mailinator.com', 'mailnesia.com', 'mintemail.com', 'moakt.com',
  'mohmal.com', 'nada.email', 'sharklasers.com', 'spamgourmet.com',
  'temp-mail.io', 'temp-mail.org', 'tempinbox.com', 'tempmail.com',
  'tempmail.net', 'tempmailo.com', 'tempr.email', 'throwawaymail.com',
  'tmpmail.org', 'trashmail.com', 'yopmail.com', 'yopmail.net',
};

/// True if the email uses a temporary inbox service.
bool isBlockedEmail(String email) {
  final at = email.trim().lastIndexOf('@');
  if (at < 0) return false;
  return blockedEmailDomains.contains(email.trim().substring(at + 1).toLowerCase());
}
