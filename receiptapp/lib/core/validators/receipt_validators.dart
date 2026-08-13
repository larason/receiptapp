/// Reusable validation helpers for the receipt form fields.
///
/// Each validator returns `null` when the value is acceptable (or empty) and
/// a user-friendly error message otherwise. Empty values are left to
/// [requiredField] so the "required" and "format" messages stay distinct.
abstract final class ReceiptValidators {
  /// Fails when [value] is null or blank.
  static String? requiredField(
    String? value, {
    String message = 'This field is required.',
  }) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  /// Fails when [value] is not a plain positive number.
  ///
  /// When [allowDecimal] is `true` a single decimal point is accepted
  /// (e.g. `250` or `14.50`).
  static String? number(
    String? value, {
    bool allowDecimal = false,
    String message = 'Enter a valid number.',
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final pattern = allowDecimal ? _decimalPattern : _integerPattern;
    return pattern.hasMatch(text) ? null : message;
  }

  /// Fails when [value] is not a valid phone number.
  ///
  /// Accepts an optional leading `+` and 9–15 digits, ignoring spaces, dashes
  /// and parentheses (e.g. `+255 744 555 123`).
  static String? phone(
    String? value, {
    String message = 'Enter a valid phone number.',
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final normalized = text.replaceAll(_phoneSeparatorsPattern, '');
    return _phonePattern.hasMatch(normalized) ? null : message;
  }

  /// Fails when [value] is not digits only.
  ///
  /// Used for the editable portion of the `A437`-prefixed voucher number.
  static String? voucherNumber(
    String? value, {
    String message = 'Enter digits only.',
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return _integerPattern.hasMatch(text) ? null : message;
  }

  static final RegExp _integerPattern = RegExp(r'^\d+$');
  static final RegExp _decimalPattern = RegExp(r'^\d+(\.\d+)?$');
  static final RegExp _phonePattern = RegExp(r'^\+?\d{9,15}$');
  static final RegExp _phoneSeparatorsPattern = RegExp(r'[\s\-\(\)]');
}
