import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/errors/error_handler.dart';
import '../models/receipt.dart';
import '../services/firestore_service.dart';

/// Holds receipt state and coordinates with [FirestoreService].
///
/// Screens observe this provider and never talk to Firestore directly.
class ReceiptProvider extends ChangeNotifier {
  ReceiptProvider({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  List<Receipt> _receipts = const [];
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  StreamSubscription<List<Receipt>>? _subscription;

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

  /// Starts listening to the receipts collection, keeping [receipts] in sync.
  void watchReceipts() {
    _subscription?.cancel();
    _subscription = _firestoreService.watchReceipts().listen(
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

  /// Loads all receipts once. When [watch] is true, keeps listening for
  /// changes after the initial load.
  Future<void> loadReceipts({bool watch = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _receipts = await _firestoreService.fetchReceipts();
      if (watch) watchReceipts();
    } catch (error) {
      _errorMessage = friendlyErrorMessage(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Persists a new receipt and returns it with its assigned id, or `null`
  /// when the operation failed (see [errorMessage]).
  Future<Receipt?> createReceipt(Receipt receipt) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final id = await _firestoreService.createReceipt(receipt);
      final saved = receipt.copyWith(id: id);
      _receipts = [saved, ..._receipts];
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
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _firestoreService.updateReceipt(receipt);
      _receipts = _receipts
          .map((r) => r.id == receipt.id ? receipt : r)
          .toList();
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
      await _firestoreService.deleteReceipt(id);
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
