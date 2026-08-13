import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/errors/error_handler.dart';
import 'firebase_options.dart';
import 'navigation/main_wraper.dart';
import 'providers/printer_provider.dart';
import 'providers/receipt_form_controller.dart';
import 'providers/receipt_provider.dart';
import 'services/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureGlobalErrorHandling();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MineralReceiptsApp());
}

class MineralReceiptsApp extends StatelessWidget {
  const MineralReceiptsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider<ReceiptProvider>(
          create: (_) => ReceiptProvider(),
        ),
        ChangeNotifierProvider<PrinterProvider>(
          create: (_) => PrinterProvider(),
        ),
        ChangeNotifierProvider<ReceiptFormController>(
          create: (_) => ReceiptFormController(),
        ),
      ],
      child: MaterialApp(
        title: 'Mineral Receipts',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F57A6)),
          useMaterial3: true,
        ),
        // Set MainWrapper as the home screen here:
        home: const MainWrapper(),
      ),
    );
  }
}
