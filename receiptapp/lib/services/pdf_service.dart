import 'dart:typed_data';

import '../models/receipt.dart';

/// Generates printable receipt PDFs.
///
/// Only the service contract is defined here; the full implementation that
/// mirrors the designed receipt layout lands in Phase 9 — PDF Generation.
class PdfService {
  /// Renders [receipt] into an in-memory PDF document.
  Future<Uint8List> generateReceiptPdf(Receipt receipt) {
    throw UnimplementedError(
      'PDF generation is implemented in Phase 9 — PDF Generation.',
    );
  }
}
