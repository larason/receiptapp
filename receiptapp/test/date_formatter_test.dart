import 'package:flutter_test/flutter_test.dart';

import 'package:receiptapp/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter.historyDate', () {
    test('formats dates in the fixed English format', () {
      expect(DateFormatter.historyDate(DateTime(2026, 7, 29)), 'Jul 29, 2026');
    });
  });

  group('DateFormatter.parseHistoryDate', () {
    test('round-trips values produced by historyDate', () {
      final date = DateTime(2026, 7, 29);
      final parsed = DateFormatter.parseHistoryDate(
        DateFormatter.historyDate(date),
      );
      expect(parsed, DateTime(2026, 7, 29));
    });

    test('parses single-digit days', () {
      expect(
        DateFormatter.parseHistoryDate('Sep 4, 2025'),
        DateTime(2025, 9, 4),
      );
    });

    test('trims surrounding whitespace', () {
      expect(
        DateFormatter.parseHistoryDate('  Jul 29, 2026  '),
        DateTime(2026, 7, 29),
      );
    });

    test('returns null for empty, invalid, or mismatched input', () {
      expect(DateFormatter.parseHistoryDate(''), isNull);
      expect(DateFormatter.parseHistoryDate('   '), isNull);
      expect(DateFormatter.parseHistoryDate('not a date'), isNull);
      expect(DateFormatter.parseHistoryDate('Jul 29 2026'), isNull);
      expect(DateFormatter.parseHistoryDate('2026-07-29'), isNull);
      expect(DateFormatter.parseHistoryDate('Jul 29, 2026 extra'), isNull);
    });
  });
}
