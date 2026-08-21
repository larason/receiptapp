/// Domain model for a mineral sale receipt.
///
/// Local-first model persisted in SQLite via Drift (Phase 3). [id] is `null`
/// until the receipt has been persisted.
class Receipt {
  const Receipt({
    this.id,
    required this.voucherNumber,
    required this.mineralType,
    required this.mineralValue,
    required this.quantity,
    required this.vehicleNumber,
    required this.transportPhone,
    required this.buyerName,
    required this.destination,
    required this.productionCenter,
    required this.sellerName,
    required this.licenseNumber,
    required this.salesDate,
    required this.qrData,
    this.createdAt,
    this.updatedAt,
  });

  /// Local database id (auto-increment) or UUID.
  final String? id;

  /// Voucher number including the `A437` prefix (e.g. `A437001`).
  final String voucherNumber;

  final String mineralType;

  /// Mineral value as a plain number string (e.g. `'1500000'`).
  ///
  /// The `TZS` currency prefix is added at presentation time.
  /// Stored as integer TZS units in SQLite (Drift) — string kept here for
  /// backward compatibility until the Drift migration converts to int.
  final String mineralValue;

  /// Quantity as entered by the user (e.g. `'250'`).
  final String quantity;

  final String vehicleNumber;
  final String transportPhone;
  final String buyerName;
  final String destination;
  final String productionCenter;
  final String sellerName;
  final String licenseNumber;
  final DateTime salesDate;

  /// Payload encoded in the receipt's QR code (receipt id or voucher number).
  final String qrData;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Receipt.fromMap(Map<String, dynamic> map, {String? id}) {
    return Receipt(
      id: id ?? map['id'] as String?,
      voucherNumber: map['voucherNumber'] as String? ?? '',
      mineralType: map['mineralType'] as String? ?? '',
      mineralValue: map['mineralValue'] as String? ?? '',
      quantity: map['quantity'] as String? ?? '',
      vehicleNumber: map['vehicleNumber'] as String? ?? '',
      transportPhone: map['transportPhone'] as String? ?? '',
      buyerName: map['buyerName'] as String? ?? '',
      destination: map['destination'] as String? ?? '',
      productionCenter: map['productionCenter'] as String? ?? '',
      sellerName: map['sellerName'] as String? ?? '',
      licenseNumber: map['licenseNumber'] as String? ?? '',
      salesDate: _toDateTime(map['salesDate']) ?? _epoch,
      qrData: map['qrData'] as String? ?? '',
      createdAt: _toDateTime(map['createdAt']),
      updatedAt: _toDateTime(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'voucherNumber': voucherNumber,
      'mineralType': mineralType,
      'mineralValue': mineralValue,
      'quantity': quantity,
      'vehicleNumber': vehicleNumber,
      'transportPhone': transportPhone,
      'buyerName': buyerName,
      'destination': destination,
      'productionCenter': productionCenter,
      'sellerName': sellerName,
      'licenseNumber': licenseNumber,
      'salesDate': salesDate.toIso8601String(),
      'qrData': qrData,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Receipt copyWith({
    String? id,
    String? voucherNumber,
    String? mineralType,
    String? mineralValue,
    String? quantity,
    String? vehicleNumber,
    String? transportPhone,
    String? buyerName,
    String? destination,
    String? productionCenter,
    String? sellerName,
    String? licenseNumber,
    DateTime? salesDate,
    String? qrData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Receipt(
      id: id ?? this.id,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      mineralType: mineralType ?? this.mineralType,
      mineralValue: mineralValue ?? this.mineralValue,
      quantity: quantity ?? this.quantity,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      transportPhone: transportPhone ?? this.transportPhone,
      buyerName: buyerName ?? this.buyerName,
      destination: destination ?? this.destination,
      productionCenter: productionCenter ?? this.productionCenter,
      sellerName: sellerName ?? this.sellerName,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      salesDate: salesDate ?? this.salesDate,
      qrData: qrData ?? this.qrData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static final DateTime _epoch = DateTime.fromMillisecondsSinceEpoch(0);

  static DateTime? _toDateTime(Object? value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }
}
