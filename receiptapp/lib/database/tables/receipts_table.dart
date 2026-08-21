import 'package:drift/drift.dart';

/// Drift table mirroring the `receipts` SQLite table.
///
/// Stores all fields of [Receipt] locally. Currency values are stored as
/// text to preserve exact user input without floating-point loss; integer
/// TZS conversion is handled at repository level if needed.
class Receipts extends Table {
  /// Primary key — UUID v4 generated in repository/provider.
  TextColumn get id => text()();

  TextColumn get mineralType => text().named('mineral_type')();
  TextColumn get voucherNumber => text().named('voucher_number')();
  TextColumn get mineralValue => text().named('mineral_value')();
  TextColumn get quantity => text()();
  TextColumn get vehicleNumber => text().named('vehicle_number')();
  TextColumn get transportPhone => text().named('transport_phone')();
  TextColumn get buyerName => text().named('buyer_name')();
  TextColumn get destination => text()();
  TextColumn get productionCenter => text().named('production_center')();
  TextColumn get sellerName => text().named('seller_name')();
  TextColumn get licenseNumber => text().named('license_number')();
  DateTimeColumn get salesDate => dateTime().named('sales_date')();
  TextColumn get qrData => text().named('qr_data')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id}
;
}
