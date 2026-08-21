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
          _receipts.sort((a, b) => b.salesDate.compareTo(a.salesDate));
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
        _receipts.sort((a, b) => b.salesDate.compareTo(a.salesDate));
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
          _receipts.sort((a, b) => b.salesDate.compareTo(a.salesDate));
        }
        return ok;
      } else {
        if (!_receipts.any((r) => r.id == receipt.id)) return false;
        final now = DateTime.now();
        final updated = receipt.copyWith(updatedAt: now);
        _receipts = _receipts.map((r) => r.id == receipt.id ? updated : r).toList();
        _receipts.sort((a, b) => b.salesDate.compareTo(a.salesDate));
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

  /// Recent receipts, newest first.
  Future<List<Receipt>> getRecentReceipts({int limit = 5}) async {
    final repo = _repository;
    if (repo != null) return repo.getRecentReceipts(limit: limit);
    final sorted = List<Receipt>.from(_receipts)..sort((a, b) => b.salesDate.compareTo(a.salesDate));
    return sorted.take(limit).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
