import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/errors/error_handler.dart';
import 'database/app_database.dart';
import 'navigation/main_wraper.dart';
import 'providers/printer_provider.dart';
import 'providers/receipt_form_controller.dart';
import 'providers/receipt_provider.dart';
import 'repositories/receipt_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureGlobalErrorHandling();
  // Drift database is lazily opened on first query — no setup screen needed.
  final db = AppDatabase();
  final repository = ReceiptRepository.fromDb(db);
  runApp(MineralReceiptsApp(database: db, repository: repository));
}

class MineralReceiptsApp extends StatelessWidget {
  const MineralReceiptsApp({
    super.key,
    this.database,
    this.repository,
  });

  final AppDatabase? database;
  final ReceiptRepository? repository;

  @override
  Widget build(BuildContext context) {
    final db = database;
    final repo = repository;
    return MultiProvider(
      providers: [
        if (db != null) Provider<AppDatabase>.value(value: db),
        if (repo != null) Provider<ReceiptRepository>.value(value: repo),
        ChangeNotifierProvider<ReceiptProvider>(
          create: (_) => ReceiptProvider(repository: repo)..loadReceipts(watch: true),
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
        home: const MainWrapper(),
      ),
    );
  }
}
