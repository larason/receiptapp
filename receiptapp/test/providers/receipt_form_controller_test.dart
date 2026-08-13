import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:receiptapp/core/constants/app_constants.dart';
import 'package:receiptapp/core/validators/receipt_validators.dart';
import 'package:receiptapp/models/receipt.dart';
import 'package:receiptapp/providers/receipt_form_controller.dart';

void main() {
  group('ReceiptFormController', () {
    test('fullVoucherNumber always starts with the A437 prefix', () {
      final controller = ReceiptFormController();
      addTearDown(controller.dispose);

      controller.voucherNumberController.text = '001';
      expect(controller.fullVoucherNumber, 'A437001');

      controller.voucherNumberController.text = ' 42 ';
      expect(controller.fullVoucherNumber, 'A43742');
    });

    test('fullMineralValue prepends the TZS currency code', () {
      final controller = ReceiptFormController();
      addTearDown(controller.dispose);

      controller.mineralValueController.text = '1500000';
      expect(controller.fullMineralValue, 'TZS 1500000');
    });

    test('updates the selected mineral type', () {
      final controller = ReceiptFormController();
      addTearDown(controller.dispose);

      expect(controller.mineralType, AppConstants.mineralTypes.first);
      controller.mineralType = 'Copper';
      expect(controller.mineralType, 'Copper');
    });
  });

  group('ReceiptFormController.validateAndBuild', () {
    testWidgets('produces a complete Receipt from valid input', (
      WidgetTester tester,
    ) async {
      final controller = ReceiptFormController(
        now: DateTime(2026, 8, 13, 14, 30),
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(_FormHarness(controller: controller));

      await tester.enterText(find.byKey(const Key('voucher')), '001');
      await tester.enterText(find.byKey(const Key('mineralValue')), '1500000');
      await tester.enterText(find.byKey(const Key('quantity')), '250');
      await tester.enterText(find.byKey(const Key('vehicle')), 'T 123 ABC');
      await tester.enterText(
        find.byKey(const Key('transportPhone')),
        '+255 744 555 123',
      );
      await tester.enterText(find.byKey(const Key('buyer')), 'John Doe');
      await tester.enterText(
        find.byKey(const Key('destination')),
        'Dar es Salaam',
      );

      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(controller.draftReceipt, isNotNull);
      final Receipt receipt = controller.draftReceipt!;

      expect(receipt.voucherNumber, 'A437001');
      expect(receipt.mineralType, AppConstants.mineralTypes.first);
      expect(receipt.mineralValue, '1500000');
      expect(receipt.quantity, '250');
      expect(receipt.vehicleNumber, 'T 123 ABC');
      expect(receipt.transportPhone, '+255 744 555 123');
      expect(receipt.buyerName, 'John Doe');
      expect(receipt.destination, 'Dar es Salaam');
      expect(receipt.productionCenter, AppConstants.defaultProductionCenter);
      expect(receipt.sellerName, AppConstants.defaultSellerName);
      expect(receipt.licenseNumber, AppConstants.defaultLicenseNumber);
      expect(receipt.salesDate, DateTime(2026, 8, 13, 14, 30));
      expect(receipt.qrData, 'A437001');
    });

    testWidgets('rejects empty required fields', (WidgetTester tester) async {
      final controller = ReceiptFormController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(_FormHarness(controller: controller));

      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(controller.validateAndBuild(), isFalse);
      expect(controller.draftReceipt, isNull);
    });

    testWidgets('rejects invalid numbers and phone numbers', (
      WidgetTester tester,
    ) async {
      final controller = ReceiptFormController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(_FormHarness(controller: controller));

      await tester.enterText(find.byKey(const Key('voucher')), '001');
      await tester.enterText(find.byKey(const Key('mineralValue')), 'abc');
      await tester.enterText(find.byKey(const Key('quantity')), '-5');
      await tester.enterText(find.byKey(const Key('vehicle')), 'T 123 ABC');
      await tester.enterText(find.byKey(const Key('transportPhone')), '123');
      await tester.enterText(find.byKey(const Key('buyer')), 'John Doe');
      await tester.enterText(
        find.byKey(const Key('destination')),
        'Dar es Salaam',
      );

      await tester.tap(find.byKey(const Key('submit')));
      await tester.pump();

      expect(controller.validateAndBuild(), isFalse);
      expect(controller.draftReceipt, isNull);
    });
  });
}

/// Minimal form that mirrors the receipt screen fields so the controller can
/// be exercised without Firebase or the full app UI.
class _FormHarness extends StatelessWidget {
  const _FormHarness({required this.controller});

  final ReceiptFormController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: controller.mineralType,
                items: AppConstants.mineralTypes
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) controller.mineralType = value;
                },
              ),
              TextFormField(
                key: const Key('voucher'),
                controller: controller.voucherNumberController,
                validator: (value) =>
                    ReceiptValidators.requiredField(value) ??
                    ReceiptValidators.voucherNumber(value),
              ),
              TextFormField(
                key: const Key('mineralValue'),
                controller: controller.mineralValueController,
                validator: (value) =>
                    ReceiptValidators.requiredField(value) ??
                    ReceiptValidators.number(value, allowDecimal: true),
              ),
              TextFormField(
                key: const Key('quantity'),
                controller: controller.quantityController,
                validator: (value) =>
                    ReceiptValidators.requiredField(value) ??
                    ReceiptValidators.number(value, allowDecimal: true),
              ),
              TextFormField(
                key: const Key('vehicle'),
                controller: controller.vehicleNumberController,
                validator: ReceiptValidators.requiredField,
              ),
              TextFormField(
                key: const Key('transportPhone'),
                controller: controller.transportPhoneController,
                validator: (value) =>
                    ReceiptValidators.requiredField(value) ??
                    ReceiptValidators.phone(value),
              ),
              TextFormField(
                key: const Key('buyer'),
                controller: controller.buyerNameController,
                validator: ReceiptValidators.requiredField,
              ),
              TextFormField(
                key: const Key('destination'),
                controller: controller.destinationController,
                validator: ReceiptValidators.requiredField,
              ),
              ElevatedButton(
                key: const Key('submit'),
                onPressed: controller.validateAndBuild,
                child: const Text('submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
