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

  /// All receipts, newest first (by salesDate, then createdAt, then id).
  Future<List<Receipt>> getAllReceipts() => (select(receipts)
        ..orderBy([
          (t) => OrderingTerm.desc(t.salesDate),
          (t) => OrderingTerm.desc(t.createdAt),
          (t) => OrderingTerm.desc(t.id),
        ]))
      .get();

  /// Reactive stream of all receipts, newest first.
  Stream<List<Receipt>> watchAllReceipts() => (select(receipts)
        ..orderBy([
          (t) => OrderingTerm.desc(t.salesDate),
          (t) => OrderingTerm.desc(t.createdAt),
          (t) => OrderingTerm.desc(t.id),
        ]))
      .watch();

  /// Paginated receipts, newest first. For History lazy-loading.
  Future<List<Receipt>> getReceiptsPaginated({
    required int limit,
    required int offset,
  }) =>
      (select(receipts)
            ..orderBy([
              (t) => OrderingTerm.desc(t.salesDate),
              (t) => OrderingTerm.desc(t.createdAt),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(limit, offset: offset))
          .get();

  Stream<List<Receipt>> watchReceiptsPaginated({
    required int limit,
    required int offset,
  }) =>
      (select(receipts)
            ..orderBy([
              (t) => OrderingTerm.desc(t.salesDate),
              (t) => OrderingTerm.desc(t.createdAt),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(limit, offset: offset))
          .watch();

  /// Count total receipts.
  Future<int> countAllReceipts() async {
    final row = await customSelect(
      'SELECT COUNT(*) AS c FROM receipts',
      readsFrom: {receipts},
    ).getSingle();
    return row.data['c'] as int;
  }

  /// Recent receipts limited by [limit], newest first.
  Future<List<Receipt>> getRecentReceipts({int limit = 10}) => (select(receipts)
        ..orderBy([
          (t) => OrderingTerm.desc(t.salesDate),
          (t) => OrderingTerm.desc(t.createdAt),
        ])
        ..limit(limit))
      .get();

  /// Reactive recent.
  Stream<List<Receipt>> watchRecentReceipts({int limit = 10}) => (select(receipts)
        ..orderBy([
          (t) => OrderingTerm.desc(t.salesDate),
          (t) => OrderingTerm.desc(t.createdAt),
        ])
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
          ..orderBy([
            (t) => OrderingTerm.desc(t.salesDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .get();
  }

  /// Search with pagination — database-level search, not in-memory Dart filtering.
  Future<List<Receipt>> searchReceiptsPaginated(
    String query, {
    required int limit,
    required int offset,
  }) {
    final q = query.trim();
    if (q.isEmpty) return getReceiptsPaginated(limit: limit, offset: offset);
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
          ..orderBy([
            (t) => OrderingTerm.desc(t.salesDate),
            (t) => OrderingTerm.desc(t.createdAt),
          ])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<int> countSearchReceipts(String query) async {
    final q = query.trim();
    if (q.isEmpty) return countAllReceipts();
    final escaped = q
        .replaceAll(r'\', r'\\')
        .replaceAll('%', r'\%')
        .replaceAll('_', r'\_');
    final pattern = '%$escaped%';
    final rows = await (selectOnly(receipts)
          ..addColumns([receipts.id.count()])
          ..where(
            receipts.voucherNumber.like(pattern, escapeChar: r'\') |
                receipts.buyerName.like(pattern, escapeChar: r'\') |
                receipts.vehicleNumber.like(pattern, escapeChar: r'\'),
          ))
        .getSingle();
    return rows.read(receipts.id.count()) ?? 0;
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
