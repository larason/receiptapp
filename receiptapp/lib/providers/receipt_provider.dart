import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/errors/error_handler.dart';
import '../models/receipt.dart';

/// Holds receipt state in memory.
///
/// Phase 2: Firebase removed. This is a temporary in-memory stub so the app
/// builds and tests pass without a backend. Phase 3 replaces this with a
/// Drift-backed implementation via ReceiptRepository → DAO → SQLite.
///
/// Screens observe this provider and never talk to the database directly.
class ReceiptProvider extends ChangeNotifier {
  ReceiptProvider();

  final Uuid _uuid = const Uuid();

  List<Receipt> _receipts = const [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  /// Receipts, newest first.
  List<Receipt> get receipts => List.unmodifiable(_receipts);

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  /// User-friendly error message from the last failed operation, if any.
  String? get errorMessage => _errorMessage;

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// No-op in Phase 2. Phase 3 will stream from Drift.
  void watchReceipts() {}

  /// Simulates a load. Phase 3 will query SQLite.
  Future<void> loadReceipts({bool watch = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // No persistent storage yet — keep current in-memory list.
      await Future<void>.delayed(Duration.zero);
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new receipt in memory and returns it with an assigned id,
  /// or `null` when the operation failed (see [errorMessage]).
  Future<Receipt?> createReceipt(Receipt receipt) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final now = DateTime.now();
      final saved = receipt.copyWith(
        id: receipt.id ?? _uuid.v4(),
        createdAt: receipt.createdAt ?? now,
        updatedAt: now,
      );
      _receipts = [saved, ..._receipts];
      _receipts.sort((a, b) => b.salesDate.compareTo(a.salesDate));
      return saved;
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
      final now = DateTime.now();
      final updated = receipt.copyWith(updatedAt: now);
      _receipts = _receipts.map((r) => r.id == receipt.id ? updated : r).toList();
      return true;
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
      _receipts = _receipts.where((r) => r.id != id).toList();
      return true;
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
