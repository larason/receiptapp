import 'package:intl/intl.dart';

/// Centralized date and time formatting helpers.
///
/// Screens and services should use these helpers instead of building
/// formatted strings inline so date formatting stays consistent app-wide.
abstract final class DateFormatter {
  /// e.g. `29 Jul 2026`
  static final DateFormat _shortDate = DateFormat('d MMM yyyy');

  /// e.g. `29 Jul 2026, 14:30`
  static final DateFormat _dateTime = DateFormat('d MMM yyyy, HH:mm');

  /// Fixed English receipt-history format, e.g. `Jul 29, 2026`.
  static final DateFormat _historyDate = DateFormat('MMM d, yyyy', 'en_US');

  /// Formats [date] as `29 Jul 2026`.
  static String shortDate(DateTime date) => _shortDate.format(date);

  /// Formats [date] as `29 Jul 2026, 14:30`.
  static String dateTime(DateTime date) => _dateTime.format(date);

  /// Formats [date] as `Jul 29, 2026` (used by receipt history).
  static String historyDate(DateTime date) => _historyDate.format(date);

  /// Parses a value produced by [historyDate] back into a [DateTime].
  ///
  /// Returns `null` when [value] is empty, invalid, or does not match the
  /// expected fixed English format (e.g. `Jul 29, 2026`).
  static DateTime? parseHistoryDate(String value) =>
      _historyDate.tryParseStrict(value.trim());
}
