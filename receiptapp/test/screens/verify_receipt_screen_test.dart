import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:receiptapp/models/receipt.dart';
import 'package:receiptapp/screens/verify_receipt_screen.dart';

void main() {
  final receipt = Receipt(
    voucherNumber: 'A437001',
    mineralType: 'Gold Concentrate',
    mineralValue: '1500000',
    quantity: '250',
    vehicleNumber: 'T 123 ABC',
    transportPhone: '+255 744 555 123',
    buyerName: 'John Doe',
    destination: 'Dar es Salaam',
    productionCenter: 'Central Mineral Hub',
    sellerName: 'Official Dealer',
    licenseNumber: 'LIC-2024-889',
    salesDate: DateTime(2026, 8, 13, 14, 30),
    qrData: 'A437001',
  );

  Widget harness(Receipt? value) {
    return MaterialApp(home: VerifyReceiptScreen(receipt: value));
  }

  testWidgets('renders customer information from the receipt', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(harness(receipt));

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('LIC-2024-889'), findsOneWidget);
    expect(find.text('+255 744 555 123'), findsOneWidget);
    expect(find.text('Dar es Salaam'), findsOneWidget);
  });

  testWidgets('renders the mineral line item, quantity, and total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(harness(receipt));

    expect(find.text('Gold Concentrate'), findsOneWidget);
    expect(find.text('GOLD'), findsOneWidget);
    expect(find.text('250'), findsOneWidget);
    expect(find.text('1,500,000 TZS'), findsOneWidget);
  });

  testWidgets('renders issue date, vehicle, and voucher number', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(harness(receipt));

    expect(find.text('Aug 13, 2026'), findsOneWidget);
    expect(find.text('T 123 ABC'), findsOneWidget);
    expect(find.text('A437001'), findsOneWidget);
  });

  testWidgets('shows placeholders when no receipt is supplied', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(harness(null));

    expect(find.text('—'), findsWidgets);
    expect(find.text('Total Payable Amount'), findsOneWidget);
    expect(find.text('Are all the details correct?'), findsOneWidget);
  });
}
