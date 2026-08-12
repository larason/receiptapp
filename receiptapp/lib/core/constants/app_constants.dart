/// Application-wide shared constants.
///
/// Values used across the app are defined here in a single place so they stay
/// consistent and easy to update.
abstract final class AppConstants {
  /// Display name of the application.
  static const String appName = 'Mineral Receipts';

  /// Prefix that every generated voucher number begins with.
  static const String voucherPrefix = 'A437';

  /// Currency code shown on mineral values.
  static const String currencyCode = 'TZS';

  /// Firestore collection that stores receipts.
  static const String receiptsCollection = 'receipts';

  /// Supported mineral types offered in the receipt form.
  static const List<String> mineralTypes = [
    'Gold Concentrate',
    'Copper',
    'Tanzanite',
    'Iron Ore',
    'Diamond',
  ];

  /// Constant business fields stamped on every receipt.
  static const String defaultProductionCenter = 'Central Mineral Hub';
  static const String defaultSellerName = 'Official Dealer';
  static const String defaultLicenseNumber = 'LIC-2024-889';
}
