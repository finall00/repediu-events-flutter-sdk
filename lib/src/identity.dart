const _defaultCountryCode = '55';
const _phoneIdPrefix = 'rpd:tel:';
const _emailIdPrefix = 'rpd:mail:';
const _mask32 = 0xFFFFFFFF;

String? normalizePhone(String? phone) {
  if (phone == null) return null;
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length == 10 || digits.length == 11) return '$_defaultCountryCode$digits';
  if (digits.length == 12 || digits.length == 13) return digits;
  return null;
}

String hashId(String value) {
  var h1 = 0x811c9dc5;
  var h2 = 0x01000193;
  for (final c in value.codeUnits) {
    h1 = ((h1 ^ c) * 0x01000193) & _mask32;
    h2 = ((h2 ^ c) * 0x85ebca6b) & _mask32;
  }
  return h1.toRadixString(16).padLeft(8, '0') + h2.toRadixString(16).padLeft(8, '0');
}

String? deriveUserId({String? userId, String? phone, String? email}) {
  final trimmedId = userId?.trim() ?? '';
  if (trimmedId.isNotEmpty) return trimmedId;

  final normalizedPhone = normalizePhone(phone);
  if (normalizedPhone != null) return '$_phoneIdPrefix${hashId(normalizedPhone)}';

  final trimmedEmail = email?.trim() ?? '';
  if (trimmedEmail.isNotEmpty) return '$_emailIdPrefix${hashId(trimmedEmail.toLowerCase())}';

  return null;
}
