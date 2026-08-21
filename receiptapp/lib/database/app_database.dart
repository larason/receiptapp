import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/receipts_dao.dart';
import 'tables/receipts_table.dart';

part 'app_database.g.dart';

/// Central Drift database for the Mineral Receipt app.
///
/// Single-user, single-device. Created lazily on first launch via
/// [LazyDatabase] — no setup screen required. Migrations preserve user data.
@DriftDatabase(tables: [Receipts], daos: [ReceiptsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For tests — inject an in-memory or temporary executor.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Indexes for frequently searched fields (AGENTS.md:233)
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_receipts_voucher_number ON receipts (voucher_number);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_receipts_buyer_name ON receipts (buyer_name);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_receipts_vehicle_number ON receipts (vehicle_number);',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_receipts_sales_date ON receipts (sales_date);',
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations must preserve data — never drop table.
        // Example for v2:
        // if (from < 2) { await m.addColumn(receipts, receipts.newColumn); }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mineral_receipts.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
