import 'package:flutter/foundation.dart';

/// Connection type of a receipt printer.
enum PrinterType { bluetooth, network }

/// Holds the selected receipt printer state.
///
/// Printer discovery, connection, and printing are implemented in
/// Phase 10 — Printer Integration. Persisting the selection locally is part
/// of Phase 11 — Local Preferences.
class PrinterProvider extends ChangeNotifier {
  String? _printerName;
  String? _printerAddress;
  PrinterType? _printerType;
  bool _isConnected = false;
  bool _isPrinting = false;

  String? get printerName => _printerName;

  /// IP address or Bluetooth MAC of the selected printer.
  String? get printerAddress => _printerAddress;

  PrinterType? get printerType => _printerType;

  bool get isConnected => _isConnected;

  bool get isPrinting => _isPrinting;

  bool get hasSelectedPrinter => _printerName != null && _printerAddress != null;

  /// Remembers the printer chosen by the user.
  void selectPrinter({
    required String name,
    required String address,
    required PrinterType type,
  }) {
    _printerName = name;
    _printerAddress = address;
    _printerType = type;
    _isConnected = false;
    notifyListeners();
  }

  void setConnected(bool value) {
    if (_isConnected != value) {
      _isConnected = value;
      notifyListeners();
    }
  }

  void setPrinting(bool value) {
    if (_isPrinting != value) {
      _isPrinting = value;
      notifyListeners();
    }
  }

  void clearSelection() {
    _printerName = null;
    _printerAddress = null;
    _printerType = null;
    _isConnected = false;
    _isPrinting = false;
    notifyListeners();
  }
}
