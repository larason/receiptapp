import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/receipt.dart';

/// Owns the create/edit receipt form state and validation logic.
///
/// Keeps business logic out of the widgets: it holds every text controller,
/// the [Form] key, the selected mineral type, and the automatically generated
/// sales timestamp. After successful validation it produces a complete
/// [Receipt] via [validateAndBuild].
class ReceiptFormController extends ChangeNotifier {
  ReceiptFormController({DateTime? now}) : salesDate = now ?? DateTime.now();

  /// Key attached to the receipt [Form] so validation can run on it.
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController voucherNumberController = TextEditingController();
  final TextEditingController mineralValueController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController transportPhoneController =
      TextEditingController();
  final TextEditingController buyerNameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  /// Timestamp stamped on the receipt, generated automatically.
  final DateTime salesDate;

  String _mineralType = AppConstants.mineralTypes.first;
  Receipt? _draftReceipt;

  /// Currently selected mineral type.
  String get mineralType => _mineralType;

  /// The last valid receipt produced by [validateAndBuild], if any.
  Receipt? get draftReceipt => _draftReceipt;

  /// Full voucher number, always prefixed with `A437`.
  String get fullVoucherNumber =>
      AppConstants.voucherPrefix + voucherNumberController.text.trim();

  /// Formatted mineral value with the `TZS` currency prefix.
  String get fullMineralValue =>
      '${AppConstants.currencyCode} ${mineralValueController.text.trim()}';

  set mineralType(String value) {
    if (_mineralType == value) return;
    _mineralType = value;
    notifyListeners();
  }

  /// Validates the form and, when valid, builds and stores [draftReceipt].
  ///
  /// Returns `true` only when every field is valid.
  bool validateAndBuild() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (!isValid) return false;
    _draftReceipt = _buildReceipt();
    notifyListeners();
    return true;
  }

  /// Builds a complete [Receipt] from the current field values.
  ///
  /// Should only be called after [validateAndBuild] has returned `true`.
  Receipt _buildReceipt() {
    final voucher = fullVoucherNumber;
    return Receipt(
      voucherNumber: voucher,
      mineralType: _mineralType,
      mineralValue: mineralValueController.text.trim(),
      quantity: quantityController.text.trim(),
      vehicleNumber: vehicleNumberController.text.trim(),
      transportPhone: transportPhoneController.text.trim(),
      buyerName: buyerNameController.text.trim(),
      destination: destinationController.text.trim(),
      productionCenter: AppConstants.defaultProductionCenter,
      sellerName: AppConstants.defaultSellerName,
      licenseNumber: AppConstants.defaultLicenseNumber,
      salesDate: salesDate,
      qrData: voucher,
    );
  }

  @override
  void dispose() {
    voucherNumberController.dispose();
    mineralValueController.dispose();
    quantityController.dispose();
    vehicleNumberController.dispose();
    transportPhoneController.dispose();
    buyerNameController.dispose();
    destinationController.dispose();
    super.dispose();
  }
}
