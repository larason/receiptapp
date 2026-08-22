// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/errors/error_handler.dart';
import '../models/receipt.dart';
import '../repositories/receipt_repository.dart';

/// Holds receipt state and coordinates with [ReceiptRepository].
///
/// Phase 3: Drift-backed. When a [ReceiptRepository] is supplied, all
/// operations go through SQLite via DAO → Drift. When no repository is
/// supplied (tests / fallback), an in-memory list is used so existing
/// widget tests continue to pass without a database.
class ReceiptProvider extends ChangeNotifier {
  ReceiptProvider({ReceiptRepository? repository}) : _repository = repository;

  final ReceiptRepository? _repository;
  final Uuid _uuid = const Uuid();

  List<Receipt> _receipts = const [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  StreamSubscription<List<Receipt>>? _subscription;

  /// Receipts, newest first.
  List<Receipt> get receipts => List.unmodifiable(_receipts);

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Starts listening to the receipts table, keeping [receipts] in sync.
  /// Uses Drift reactive stream when repository is available.
  void watchReceipts() {
    final repo = _repository;
    if (repo == null) return;
    _subscription?.cancel();
    _subscription = repo.watchAllReceipts().listen(
      (receipts) {
        _receipts = receipts;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _errorMessage = friendlyErrorMessage(error);
        notifyListeners();
      },
    );
  }

  /// Loads all receipts. When [watch] is true, keeps listening for changes.
  Future<void> loadReceipts({bool watch = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final repo = _repository;
      if (repo != null) {
        _receipts = await repo.getAllReceipts();
        if (watch) watchReceipts();
      } else {
        // In-memory fallback — keep current list.
        await Future<void>.delayed(Duration.zero);
      }
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Individual receipt read.
  Future<Receipt?> getReceipt(String id) async {
    final repo = _repository;
    if (repo != null) return repo.getReceipt(id);
    try {
      return _receipts.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<int> countAllReceipts() async {
    final repo = _repository;
    if (repo != null) return repo.countAllReceipts();
    return _receipts.length;
  }

  Future<int> countSearchReceipts(String query) async {
    final repo = _repository;
    if (repo != null) return repo.countSearchReceipts(query);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _receipts.length;
    return _receipts
        .where(
          (r) =>
              r.voucherNumber.toLowerCase().contains(q) ||
              r.buyerName.toLowerCase().contains(q) ||
              r.vehicleNumber.toLowerCase().contains(q),
        )
        .length;
  }

  /// Persists a new receipt and returns it with its assigned id, or `null` on failure.
  Future<Receipt?> createReceipt(Receipt receipt) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final repo = _repository;
      if (repo != null) {
        // Duplicate guard mirrors in-memory behavior.
        if (receipt.id != null) {
          final existing = await repo.getReceipt(receipt.id!);
          if (existing != null) {
            _errorMessage = 'A receipt with this identifier already exists.';
            return null;
          }
        }
        final saved = await repo.createReceipt(receipt);
        // Optimistic update — stream will also sync.
        if (!_receipts.any((r) => r.id == saved.id)) {
          _receipts = [saved, ..._receipts];
          _receipts.sort(_newestFirst);
        }
        return saved;
      } else {
        final now = DateTime.now();
        if (receipt.id != null && _receipts.any((r) => r.id == receipt.id)) {
          _errorMessage = 'A receipt with this identifier already exists.';
          return null;
        }
        final saved = receipt.copyWith(
          id: receipt.id ?? _uuid.v4(),
          createdAt: receipt.createdAt ?? now,
          updatedAt: now,
        );
        _receipts = [saved, ..._receipts];
        _receipts.sort(_newestFirst);
        return saved;
      }
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Updates an existing receipt. Returns `false` on failure.
  Future<bool> updateReceipt(Receipt receipt) async {
    if (receipt.id == null) {
      _errorMessage = 'Cannot update a receipt without an id.';
      notifyListeners();
      return false;
    }
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final repo = _repository;
      if (repo != null) {
        final existing = await repo.getReceipt(receipt.id!);
        if (existing == null) return false;
        final ok = await repo.updateReceipt(receipt);
        if (ok) {
          final persisted = await repo.getReceipt(receipt.id!);
          final toStore = persisted ?? receipt.copyWith(updatedAt: DateTime.now());
          _receipts = _receipts.map((r) => r.id == receipt.id ? toStore : r).toList();
          _receipts.sort(_newestFirst);
        }
        return ok;
      } else {
        if (!_receipts.any((r) => r.id == receipt.id)) return false;
        final now = DateTime.now();
        final updated = receipt.copyWith(updatedAt: now);
        _receipts = _receipts.map((r) => r.id == receipt.id ? updated : r).toList();
        _receipts.sort(_newestFirst);
        return true;
      }
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Deletes the receipt with [id]. Returns `false` on failure.
  Future<bool> deleteReceipt(String id) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final repo = _repository;
      if (repo != null) {
        final ok = await repo.deleteReceipt(id);
        if (ok) {
          _receipts = _receipts.where((r) => r.id != id).toList();
        }
        return ok;
      } else {
        _receipts = _receipts.where((r) => r.id != id).toList();
        return true;
      }
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Search receipts by voucher, buyer, or vehicle (delegates to repository when available).
  /// Uses database-level LIKE when repository is present — no in-memory filtering for large datasets.
  Future<List<Receipt>> searchReceipts(String query) async {
    final repo = _repository;
    if (repo != null) {
      return repo.searchReceipts(query);
    }
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return receipts;
    return _receipts
        .where(
          (r) =>
              r.voucherNumber.toLowerCase().contains(q) ||
              r.buyerName.toLowerCase().contains(q) ||
              r.vehicleNumber.toLowerCase().contains(q),
        )
        .toList();
  }

  /// Database-level paginated search — preferred for History.
  Future<List<Receipt>> searchReceiptsPaginated(
    String query, {
    required int limit,
    required int offset,
  }) async {
    final repo = _repository;
    if (repo != null) {
      return repo.searchReceiptsPaginated(query, limit: limit, offset: offset);
    }
    final all = List<Receipt>.from(await searchReceipts(query));
    all.sort(_newestFirst);
    if (offset >= all.length) return [];
    return all.skip(offset).take(limit).toList();
  }

  /// Paginated read for History — database-level limit/offset.
  Future<List<Receipt>> getReceiptsPaginated({
    required int limit,
    required int offset,
  }) async {
    final repo = _repository;
    if (repo != null) return repo.getReceiptsPaginated(limit: limit, offset: offset);
    final sorted = List<Receipt>.from(_receipts)..sort(_newestFirst);
    if (offset >= sorted.length) return [];
    return sorted.skip(offset).take(limit).toList();
  }

  /// Recent receipts, newest first.
  Future<List<Receipt>> getRecentReceipts({int limit = 5}) async {
    final repo = _repository;
    if (repo != null) return repo.getRecentReceipts(limit: limit);
    final sorted = List<Receipt>.from(_receipts)..sort(_newestFirst);
    return sorted.take(limit).toList();
  }

  int _compareNewest(Receipt a, Receipt b) {
    final c = b.salesDate.compareTo(a.salesDate);
    if (c != 0) return c;
    final ca = a.createdAt;
    final cb = b.createdAt;
    if (ca == null && cb == null) {
      // fall through to id
    } else if (ca == null) {
      return 1;
    } else if (cb == null) {
      return -1;
    } else {
      final c2 = cb.compareTo(ca);
      if (c2 != 0) return c2;
    }
    // Final deterministic tie-breaker — matches DAO's id desc
    final ida = a.id ?? '';
    final idb = b.id ?? '';
    return idb.compareTo(ida);
  }

  int Function(Receipt, Receipt) get _newestFirst => _compareNewest;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
