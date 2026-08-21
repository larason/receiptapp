import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/receipts_table.dart';

part 'receipts_dao.g.dart';

/// Data Access Object for the `receipts` table.
///
/// All SQL lives here. UI → Provider → Repository → DAO → Drift → SQLite.
@DriftAccessor(tables: [Receipts])
class ReceiptsDao extends DatabaseAccessor<AppDatabase>
    with _$ReceiptsDaoMixin {
  ReceiptsDao(super.db);

  /// Inserts a new receipt. Fails if id already exists (primary key).
  Future<void> insertReceipt(ReceiptsCompanion companion) =>
      into(receipts).insert(companion);

  /// Returns receipt by id or null.
  Future<Receipt?> getReceiptById(String id) =>
      (select(receipts)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// All receipts, newest first (by salesDate).
  Future<List<Receipt>> getAllReceipts() =>
      (select(receipts)..orderBy([(t) => OrderingTerm.desc(t.salesDate)])).get();

  /// Reactive stream of all receipts, newest first.
  Stream<List<Receipt>> watchAllReceipts() =>
      (select(receipts)..orderBy([(t) => OrderingTerm.desc(t.salesDate)]))
          .watch();

  /// Recent receipts limited by [limit], newest first.
  Future<List<Receipt>> getRecentReceipts({int limit = 10}) =>
      (select(receipts)
            ..orderBy([(t) => OrderingTerm.desc(t.salesDate)])
            ..limit(limit))
          .get();

  /// Reactive recent.
  Stream<List<Receipt>> watchRecentReceipts({int limit = 10}) =>
      (select(receipts)
            ..orderBy([(t) => OrderingTerm.desc(t.salesDate)])
            ..limit(limit))
          .watch();

  /// Search by voucher_number, buyer_name, vehicle_number (case-insensitive LIKE).
  /// Empty query returns all receipts. Wildcards are escaped so `%`/`_` are
  /// treated literally (ESCAPE '\').
  Future<List<Receipt>> searchReceipts(String query) {
    final q = query.trim();
    if (q.isEmpty) return getAllReceipts();
    final escaped = q
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    final pattern = '%$escaped%';
    return (select(receipts)
          ..where(
            (t) =>
                t.voucherNumber.like(pattern, escapeChar: r'\') |
                t.buyerName.like(pattern, escapeChar: r'\') |
                t.vehicleNumber.like(pattern, escapeChar: r'\'),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.salesDate)]))
        .get();
  }

  /// Updates an existing receipt (matched by id). Returns true if row was updated.
  Future<bool> updateReceipt(ReceiptsCompanion companion) =>
      update(receipts).replace(companion);

  /// Deletes by id. Returns number of rows deleted.
  Future<int> deleteReceipt(String id) =>
      (delete(receipts)..where((t) => t.id.equals(id))).go();

  /// Deletes all — for testing only.
  Future<int> deleteAll() => delete(receipts).go();
}
