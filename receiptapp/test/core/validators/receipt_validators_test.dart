import 'package:flutter_test/flutter_test.dart';

import 'package:receiptapp/core/validators/receipt_validators.dart';

void main() {
  group('ReceiptValidators.requiredField', () {
    test('accepts non-empty values', () {
      expect(ReceiptValidators.requiredField('text'), isNull);
      expect(ReceiptValidators.requiredField('  text  '), isNull);
    });

    test('rejects null and blank values', () {
      expect(ReceiptValidators.requiredField(null), isNotNull);
      expect(ReceiptValidators.requiredField(''), isNotNull);
      expect(ReceiptValidators.requiredField('   '), isNotNull);
    });
  });

  group('ReceiptValidators.number', () {
    test('accepts plain positive integers', () {
      expect(ReceiptValidators.number('0'), isNull);
      expect(ReceiptValidators.number('250'), isNull);
      expect(ReceiptValidators.number('18000'), isNull);
    });

    test('rejects non-numeric input', () {
      expect(ReceiptValidators.number('abc'), isNotNull);
      expect(ReceiptValidators.number('12a'), isNotNull);
      expect(ReceiptValidators.number('-5'), isNotNull);
      expect(ReceiptValidators.number('1,000'), isNotNull);
      expect(ReceiptValidators.number('1.5'), isNotNull);
    });

    test('allows decimals only when requested', () {
      expect(ReceiptValidators.number('14.50'), isNotNull);
      expect(ReceiptValidators.number('14.50', allowDecimal: true), isNull);
      expect(ReceiptValidators.number('1.5.2', allowDecimal: true), isNotNull);
    });
  });

  group('ReceiptValidators.phone', () {
    test('accepts valid phone numbers', () {
      expect(ReceiptValidators.phone('+255744555123'), isNull);
      expect(ReceiptValidators.phone('+255 744 555 123'), isNull);
      expect(ReceiptValidators.phone('0744555123'), isNull);
      expect(ReceiptValidators.phone('255-744-555-123'), isNull);
    });

    test('rejects invalid phone numbers', () {
      expect(ReceiptValidators.phone('123'), isNotNull);
      expect(ReceiptValidators.phone('+255 abc def ghi'), isNotNull);
      expect(ReceiptValidators.phone('phone'), isNotNull);
    });
  });

  group('ReceiptValidators.voucherNumber', () {
    test('accepts digits only', () {
      expect(ReceiptValidators.voucherNumber('001'), isNull);
      expect(ReceiptValidators.voucherNumber('2024'), isNull);
    });

    test('rejects non-digit input', () {
      expect(ReceiptValidators.voucherNumber('A437001'), isNotNull);
      expect(ReceiptValidators.voucherNumber('12a'), isNotNull);
      expect(ReceiptValidators.voucherNumber('1.5'), isNotNull);
    });
  });
}
