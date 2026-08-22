import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/daos/receipts_dao.dart';
import '../models/receipt.dart' as domain;

/// Repository hiding Drift/DAO details from providers.
///
/// UI → Provider → Repository → DAO → Drift → SQLite
/// All queries are database-level — no in-memory Dart filtering for large datasets.
class ReceiptRepository {
  ReceiptRepository(this._dao);

  /// Convenience ctor from database.
  ReceiptRepository.fromDb(AppDatabase db) : _dao = db.receiptsDao;

  final ReceiptsDao _dao;
  final Uuid _uuid = const Uuid();

  /// Creates a new receipt. Generates UUID if [receipt.id] is null.
  /// Returns the persisted receipt with id/createdAt/updatedAt stamped.
  /// Throws if id already exists (caller should handle friendly message).
  Future<domain.Receipt> createReceipt(domain.Receipt receipt) async {
    final now = DateTime.now();
    final id = receipt.id ?? _uuid.v4();

    // Duplicate id guard — matches Phase 2 in-memory behavior.
    if (receipt.id != null) {
      final existing = await _dao.getReceiptById(receipt.id!);
      if (existing != null) {
        throw Exception('A receipt with this identifier already exists.');
      }
    }

    final companion = ReceiptsCompanion(
      id: Value(id),
      mineralType: Value(receipt.mineralType),
      voucherNumber: Value(receipt.voucherNumber),
      mineralValue: Value(receipt.mineralValue),
      quantity: Value(receipt.quantity),
      vehicleNumber: Value(receipt.vehicleNumber),
      transportPhone: Value(receipt.transportPhone),
      buyerName: Value(receipt.buyerName),
      destination: Value(receipt.destination),
      productionCenter: Value(receipt.productionCenter),
      sellerName: Value(receipt.sellerName),
      licenseNumber: Value(receipt.licenseNumber),
      salesDate: Value(receipt.salesDate),
      qrData: Value(receipt.qrData),
      createdAt: Value(receipt.createdAt ?? now),
      updatedAt: Value(now),
    );
    await _dao.insertReceipt(companion);
    return receipt.copyWith(
      id: id,
      createdAt: receipt.createdAt ?? now,
      updatedAt: now,
    );
  }

  Future<domain.Receipt?> getReceipt(String id) async {
    final row = await _dao.getReceiptById(id);
    return row == null ? null : _toDomain(row);
  }

  Future<List<domain.Receipt>> getAllReceipts() async {
    final rows = await _dao.getAllReceipts();
    return rows.map(_toDomain).toList();
  }

  Stream<List<domain.Receipt>> watchAllReceipts() =>
      _dao.watchAllReceipts().map((rows) => rows.map(_toDomain).toList());

  /// Paginated read — for History lazy-loading, avoids loading entire table.
  Future<List<domain.Receipt>> getReceiptsPaginated({
    required int limit,
    required int offset,
  }) async {
    final rows = await _dao.getReceiptsPaginated(limit: limit, offset: offset);
    return rows.map(_toDomain).toList();
  }

  Stream<List<domain.Receipt>> watchReceiptsPaginated({
    required int limit,
    required int offset,
  }) =>
      _dao
          .watchReceiptsPaginated(limit: limit, offset: offset)
          .map((rows) => rows.map(_toDomain).toList());

  Future<int> countAllReceipts() => _dao.countAllReceipts();

  Future<List<domain.Receipt>> getRecentReceipts({int limit = 10}) async {
    final rows = await _dao.getRecentReceipts(limit: limit);
    return rows.map(_toDomain).toList();
  }

  Stream<List<domain.Receipt>> watchRecentReceipts({int limit = 10}) => _dao
      .watchRecentReceipts(limit: limit)
      .map((rows) => rows.map(_toDomain).toList());

  Future<List<domain.Receipt>> searchReceipts(String query) async {
    final rows = await _dao.searchReceipts(query);
    return rows.map(_toDomain).toList();
  }

  /// Database-level search with pagination — preferred for large history.
  Future<List<domain.Receipt>> searchReceiptsPaginated(
    String query, {
    required int limit,
    required int offset,
  }) async {
    final rows = await _dao.searchReceiptsPaginated(
      query,
      limit: limit,
      offset: offset,
    );
    return rows.map(_toDomain).toList();
  }

  Future<int> countSearchReceipts(String query) =>
      _dao.countSearchReceipts(query);

  /// Updates existing receipt. Returns true if updated, false if not found.
  /// Preserves original createdAt, stamps new updatedAt.
  Future<bool> updateReceipt(domain.Receipt receipt) async {
    final id = receipt.id;
    if (id == null) return false;
    final existing = await _dao.getReceiptById(id);
    if (existing == null) return false;

    final companion = ReceiptsCompanion(
      id: Value(id),
      mineralType: Value(receipt.mineralType),
      voucherNumber: Value(receipt.voucherNumber),
      mineralValue: Value(receipt.mineralValue),
      quantity: Value(receipt.quantity),
      vehicleNumber: Value(receipt.vehicleNumber),
      transportPhone: Value(receipt.transportPhone),
      buyerName: Value(receipt.buyerName),
      destination: Value(receipt.destination),
      productionCenter: Value(receipt.productionCenter),
      sellerName: Value(receipt.sellerName),
      licenseNumber: Value(receipt.licenseNumber),
      salesDate: Value(receipt.salesDate),
      qrData: Value(receipt.qrData),
      createdAt: Value(existing.createdAt),
      updatedAt: Value(DateTime.now()),
    );
    return _dao.updateReceipt(companion);
  }

  /// Deletes by id. Returns true if row was deleted.
  Future<bool> deleteReceipt(String id) async {
    final count = await _dao.deleteReceipt(id);
    return count > 0;
  }

  domain.Receipt _toDomain(Receipt row) {
    return domain.Receipt(
      id: row.id,
      voucherNumber: row.voucherNumber,
      mineralType: row.mineralType,
      mineralValue: row.mineralValue,
      quantity: row.quantity,
      vehicleNumber: row.vehicleNumber,
      transportPhone: row.transportPhone,
      buyerName: row.buyerName,
      destination: row.destination,
      productionCenter: row.productionCenter,
      sellerName: row.sellerName,
      licenseNumber: row.licenseNumber,
      salesDate: row.salesDate,
      qrData: row.qrData,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
