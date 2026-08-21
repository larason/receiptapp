// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ReceiptsTable extends Receipts with TableInfo<$ReceiptsTable, Receipt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceiptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mineralTypeMeta = const VerificationMeta(
    'mineralType',
  );
  @override
  late final GeneratedColumn<String> mineralType = GeneratedColumn<String>(
    'mineral_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voucherNumberMeta = const VerificationMeta(
    'voucherNumber',
  );
  @override
  late final GeneratedColumn<String> voucherNumber = GeneratedColumn<String>(
    'voucher_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mineralValueMeta = const VerificationMeta(
    'mineralValue',
  );
  @override
  late final GeneratedColumn<String> mineralValue = GeneratedColumn<String>(
    'mineral_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<String> quantity = GeneratedColumn<String>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vehicleNumberMeta = const VerificationMeta(
    'vehicleNumber',
  );
  @override
  late final GeneratedColumn<String> vehicleNumber = GeneratedColumn<String>(
    'vehicle_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transportPhoneMeta = const VerificationMeta(
    'transportPhone',
  );
  @override
  late final GeneratedColumn<String> transportPhone = GeneratedColumn<String>(
    'transport_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buyerNameMeta = const VerificationMeta(
    'buyerName',
  );
  @override
  late final GeneratedColumn<String> buyerName = GeneratedColumn<String>(
    'buyer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productionCenterMeta = const VerificationMeta(
    'productionCenter',
  );
  @override
  late final GeneratedColumn<String> productionCenter = GeneratedColumn<String>(
    'production_center',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellerNameMeta = const VerificationMeta(
    'sellerName',
  );
  @override
  late final GeneratedColumn<String> sellerName = GeneratedColumn<String>(
    'seller_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _licenseNumberMeta = const VerificationMeta(
    'licenseNumber',
  );
  @override
  late final GeneratedColumn<String> licenseNumber = GeneratedColumn<String>(
    'license_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salesDateMeta = const VerificationMeta(
    'salesDate',
  );
  @override
  late final GeneratedColumn<DateTime> salesDate = GeneratedColumn<DateTime>(
    'sales_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qrDataMeta = const VerificationMeta('qrData');
  @override
  late final GeneratedColumn<String> qrData = GeneratedColumn<String>(
    'qr_data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    mineralType,
    voucherNumber,
    mineralValue,
    quantity,
    vehicleNumber,
    transportPhone,
    buyerName,
    destination,
    productionCenter,
    sellerName,
    licenseNumber,
    salesDate,
    qrData,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Receipt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('mineral_type')) {
      context.handle(
        _mineralTypeMeta,
        mineralType.isAcceptableOrUnknown(
          data['mineral_type']!,
          _mineralTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mineralTypeMeta);
    }
    if (data.containsKey('voucher_number')) {
      context.handle(
        _voucherNumberMeta,
        voucherNumber.isAcceptableOrUnknown(
          data['voucher_number']!,
          _voucherNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_voucherNumberMeta);
    }
    if (data.containsKey('mineral_value')) {
      context.handle(
        _mineralValueMeta,
        mineralValue.isAcceptableOrUnknown(
          data['mineral_value']!,
          _mineralValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mineralValueMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('vehicle_number')) {
      context.handle(
        _vehicleNumberMeta,
        vehicleNumber.isAcceptableOrUnknown(
          data['vehicle_number']!,
          _vehicleNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vehicleNumberMeta);
    }
    if (data.containsKey('transport_phone')) {
      context.handle(
        _transportPhoneMeta,
        transportPhone.isAcceptableOrUnknown(
          data['transport_phone']!,
          _transportPhoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transportPhoneMeta);
    }
    if (data.containsKey('buyer_name')) {
      context.handle(
        _buyerNameMeta,
        buyerName.isAcceptableOrUnknown(data['buyer_name']!, _buyerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_buyerNameMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('production_center')) {
      context.handle(
        _productionCenterMeta,
        productionCenter.isAcceptableOrUnknown(
          data['production_center']!,
          _productionCenterMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productionCenterMeta);
    }
    if (data.containsKey('seller_name')) {
      context.handle(
        _sellerNameMeta,
        sellerName.isAcceptableOrUnknown(data['seller_name']!, _sellerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_sellerNameMeta);
    }
    if (data.containsKey('license_number')) {
      context.handle(
        _licenseNumberMeta,
        licenseNumber.isAcceptableOrUnknown(
          data['license_number']!,
          _licenseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_licenseNumberMeta);
    }
    if (data.containsKey('sales_date')) {
      context.handle(
        _salesDateMeta,
        salesDate.isAcceptableOrUnknown(data['sales_date']!, _salesDateMeta),
      );
    } else if (isInserting) {
      context.missing(_salesDateMeta);
    }
    if (data.containsKey('qr_data')) {
      context.handle(
        _qrDataMeta,
        qrData.isAcceptableOrUnknown(data['qr_data']!, _qrDataMeta),
      );
    } else if (isInserting) {
      context.missing(_qrDataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Receipt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Receipt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      mineralType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mineral_type'],
      )!,
      voucherNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voucher_number'],
      )!,
      mineralValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mineral_value'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quantity'],
      )!,
      vehicleNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vehicle_number'],
      )!,
      transportPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transport_phone'],
      )!,
      buyerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buyer_name'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      productionCenter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}production_center'],
      )!,
      sellerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seller_name'],
      )!,
      licenseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}license_number'],
      )!,
      salesDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sales_date'],
      )!,
      qrData: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_data'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReceiptsTable createAlias(String alias) {
    return $ReceiptsTable(attachedDatabase, alias);
  }
}

class Receipt extends DataClass implements Insertable<Receipt> {
  /// Primary key — UUID v4 generated in repository/provider.
  final String id;
  final String mineralType;
  final String voucherNumber;
  final String mineralValue;
  final String quantity;
  final String vehicleNumber;
  final String transportPhone;
  final String buyerName;
  final String destination;
  final String productionCenter;
  final String sellerName;
  final String licenseNumber;
  final DateTime salesDate;
  final String qrData;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Receipt({
    required this.id,
    required this.mineralType,
    required this.voucherNumber,
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
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['mineral_type'] = Variable<String>(mineralType);
    map['voucher_number'] = Variable<String>(voucherNumber);
    map['mineral_value'] = Variable<String>(mineralValue);
    map['quantity'] = Variable<String>(quantity);
    map['vehicle_number'] = Variable<String>(vehicleNumber);
    map['transport_phone'] = Variable<String>(transportPhone);
    map['buyer_name'] = Variable<String>(buyerName);
    map['destination'] = Variable<String>(destination);
    map['production_center'] = Variable<String>(productionCenter);
    map['seller_name'] = Variable<String>(sellerName);
    map['license_number'] = Variable<String>(licenseNumber);
    map['sales_date'] = Variable<DateTime>(salesDate);
    map['qr_data'] = Variable<String>(qrData);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReceiptsCompanion toCompanion(bool nullToAbsent) {
    return ReceiptsCompanion(
      id: Value(id),
      mineralType: Value(mineralType),
      voucherNumber: Value(voucherNumber),
      mineralValue: Value(mineralValue),
      quantity: Value(quantity),
      vehicleNumber: Value(vehicleNumber),
      transportPhone: Value(transportPhone),
      buyerName: Value(buyerName),
      destination: Value(destination),
      productionCenter: Value(productionCenter),
      sellerName: Value(sellerName),
      licenseNumber: Value(licenseNumber),
      salesDate: Value(salesDate),
      qrData: Value(qrData),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Receipt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Receipt(
      id: serializer.fromJson<String>(json['id']),
      mineralType: serializer.fromJson<String>(json['mineralType']),
      voucherNumber: serializer.fromJson<String>(json['voucherNumber']),
      mineralValue: serializer.fromJson<String>(json['mineralValue']),
      quantity: serializer.fromJson<String>(json['quantity']),
      vehicleNumber: serializer.fromJson<String>(json['vehicleNumber']),
      transportPhone: serializer.fromJson<String>(json['transportPhone']),
      buyerName: serializer.fromJson<String>(json['buyerName']),
      destination: serializer.fromJson<String>(json['destination']),
      productionCenter: serializer.fromJson<String>(json['productionCenter']),
      sellerName: serializer.fromJson<String>(json['sellerName']),
      licenseNumber: serializer.fromJson<String>(json['licenseNumber']),
      salesDate: serializer.fromJson<DateTime>(json['salesDate']),
      qrData: serializer.fromJson<String>(json['qrData']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mineralType': serializer.toJson<String>(mineralType),
      'voucherNumber': serializer.toJson<String>(voucherNumber),
      'mineralValue': serializer.toJson<String>(mineralValue),
      'quantity': serializer.toJson<String>(quantity),
      'vehicleNumber': serializer.toJson<String>(vehicleNumber),
      'transportPhone': serializer.toJson<String>(transportPhone),
      'buyerName': serializer.toJson<String>(buyerName),
      'destination': serializer.toJson<String>(destination),
      'productionCenter': serializer.toJson<String>(productionCenter),
      'sellerName': serializer.toJson<String>(sellerName),
      'licenseNumber': serializer.toJson<String>(licenseNumber),
      'salesDate': serializer.toJson<DateTime>(salesDate),
      'qrData': serializer.toJson<String>(qrData),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Receipt copyWith({
    String? id,
    String? mineralType,
    String? voucherNumber,
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
  }) => Receipt(
    id: id ?? this.id,
    mineralType: mineralType ?? this.mineralType,
    voucherNumber: voucherNumber ?? this.voucherNumber,
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
  Receipt copyWithCompanion(ReceiptsCompanion data) {
    return Receipt(
      id: data.id.present ? data.id.value : this.id,
      mineralType: data.mineralType.present
          ? data.mineralType.value
          : this.mineralType,
      voucherNumber: data.voucherNumber.present
          ? data.voucherNumber.value
          : this.voucherNumber,
      mineralValue: data.mineralValue.present
          ? data.mineralValue.value
          : this.mineralValue,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      vehicleNumber: data.vehicleNumber.present
          ? data.vehicleNumber.value
          : this.vehicleNumber,
      transportPhone: data.transportPhone.present
          ? data.transportPhone.value
          : this.transportPhone,
      buyerName: data.buyerName.present ? data.buyerName.value : this.buyerName,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      productionCenter: data.productionCenter.present
          ? data.productionCenter.value
          : this.productionCenter,
      sellerName: data.sellerName.present
          ? data.sellerName.value
          : this.sellerName,
      licenseNumber: data.licenseNumber.present
          ? data.licenseNumber.value
          : this.licenseNumber,
      salesDate: data.salesDate.present ? data.salesDate.value : this.salesDate,
      qrData: data.qrData.present ? data.qrData.value : this.qrData,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Receipt(')
          ..write('id: $id, ')
          ..write('mineralType: $mineralType, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('mineralValue: $mineralValue, ')
          ..write('quantity: $quantity, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('transportPhone: $transportPhone, ')
          ..write('buyerName: $buyerName, ')
          ..write('destination: $destination, ')
          ..write('productionCenter: $productionCenter, ')
          ..write('sellerName: $sellerName, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('salesDate: $salesDate, ')
          ..write('qrData: $qrData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    mineralType,
    voucherNumber,
    mineralValue,
    quantity,
    vehicleNumber,
    transportPhone,
    buyerName,
    destination,
    productionCenter,
    sellerName,
    licenseNumber,
    salesDate,
    qrData,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Receipt &&
          other.id == this.id &&
          other.mineralType == this.mineralType &&
          other.voucherNumber == this.voucherNumber &&
          other.mineralValue == this.mineralValue &&
          other.quantity == this.quantity &&
          other.vehicleNumber == this.vehicleNumber &&
          other.transportPhone == this.transportPhone &&
          other.buyerName == this.buyerName &&
          other.destination == this.destination &&
          other.productionCenter == this.productionCenter &&
          other.sellerName == this.sellerName &&
          other.licenseNumber == this.licenseNumber &&
          other.salesDate == this.salesDate &&
          other.qrData == this.qrData &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReceiptsCompanion extends UpdateCompanion<Receipt> {
  final Value<String> id;
  final Value<String> mineralType;
  final Value<String> voucherNumber;
  final Value<String> mineralValue;
  final Value<String> quantity;
  final Value<String> vehicleNumber;
  final Value<String> transportPhone;
  final Value<String> buyerName;
  final Value<String> destination;
  final Value<String> productionCenter;
  final Value<String> sellerName;
  final Value<String> licenseNumber;
  final Value<DateTime> salesDate;
  final Value<String> qrData;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReceiptsCompanion({
    this.id = const Value.absent(),
    this.mineralType = const Value.absent(),
    this.voucherNumber = const Value.absent(),
    this.mineralValue = const Value.absent(),
    this.quantity = const Value.absent(),
    this.vehicleNumber = const Value.absent(),
    this.transportPhone = const Value.absent(),
    this.buyerName = const Value.absent(),
    this.destination = const Value.absent(),
    this.productionCenter = const Value.absent(),
    this.sellerName = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.salesDate = const Value.absent(),
    this.qrData = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceiptsCompanion.insert({
    required String id,
    required String mineralType,
    required String voucherNumber,
    required String mineralValue,
    required String quantity,
    required String vehicleNumber,
    required String transportPhone,
    required String buyerName,
    required String destination,
    required String productionCenter,
    required String sellerName,
    required String licenseNumber,
    required DateTime salesDate,
    required String qrData,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mineralType = Value(mineralType),
       voucherNumber = Value(voucherNumber),
       mineralValue = Value(mineralValue),
       quantity = Value(quantity),
       vehicleNumber = Value(vehicleNumber),
       transportPhone = Value(transportPhone),
       buyerName = Value(buyerName),
       destination = Value(destination),
       productionCenter = Value(productionCenter),
       sellerName = Value(sellerName),
       licenseNumber = Value(licenseNumber),
       salesDate = Value(salesDate),
       qrData = Value(qrData),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Receipt> custom({
    Expression<String>? id,
    Expression<String>? mineralType,
    Expression<String>? voucherNumber,
    Expression<String>? mineralValue,
    Expression<String>? quantity,
    Expression<String>? vehicleNumber,
    Expression<String>? transportPhone,
    Expression<String>? buyerName,
    Expression<String>? destination,
    Expression<String>? productionCenter,
    Expression<String>? sellerName,
    Expression<String>? licenseNumber,
    Expression<DateTime>? salesDate,
    Expression<String>? qrData,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mineralType != null) 'mineral_type': mineralType,
      if (voucherNumber != null) 'voucher_number': voucherNumber,
      if (mineralValue != null) 'mineral_value': mineralValue,
      if (quantity != null) 'quantity': quantity,
      if (vehicleNumber != null) 'vehicle_number': vehicleNumber,
      if (transportPhone != null) 'transport_phone': transportPhone,
      if (buyerName != null) 'buyer_name': buyerName,
      if (destination != null) 'destination': destination,
      if (productionCenter != null) 'production_center': productionCenter,
      if (sellerName != null) 'seller_name': sellerName,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (salesDate != null) 'sales_date': salesDate,
      if (qrData != null) 'qr_data': qrData,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceiptsCompanion copyWith({
    Value<String>? id,
    Value<String>? mineralType,
    Value<String>? voucherNumber,
    Value<String>? mineralValue,
    Value<String>? quantity,
    Value<String>? vehicleNumber,
    Value<String>? transportPhone,
    Value<String>? buyerName,
    Value<String>? destination,
    Value<String>? productionCenter,
    Value<String>? sellerName,
    Value<String>? licenseNumber,
    Value<DateTime>? salesDate,
    Value<String>? qrData,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReceiptsCompanion(
      id: id ?? this.id,
      mineralType: mineralType ?? this.mineralType,
      voucherNumber: voucherNumber ?? this.voucherNumber,
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
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mineralType.present) {
      map['mineral_type'] = Variable<String>(mineralType.value);
    }
    if (voucherNumber.present) {
      map['voucher_number'] = Variable<String>(voucherNumber.value);
    }
    if (mineralValue.present) {
      map['mineral_value'] = Variable<String>(mineralValue.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<String>(quantity.value);
    }
    if (vehicleNumber.present) {
      map['vehicle_number'] = Variable<String>(vehicleNumber.value);
    }
    if (transportPhone.present) {
      map['transport_phone'] = Variable<String>(transportPhone.value);
    }
    if (buyerName.present) {
      map['buyer_name'] = Variable<String>(buyerName.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (productionCenter.present) {
      map['production_center'] = Variable<String>(productionCenter.value);
    }
    if (sellerName.present) {
      map['seller_name'] = Variable<String>(sellerName.value);
    }
    if (licenseNumber.present) {
      map['license_number'] = Variable<String>(licenseNumber.value);
    }
    if (salesDate.present) {
      map['sales_date'] = Variable<DateTime>(salesDate.value);
    }
    if (qrData.present) {
      map['qr_data'] = Variable<String>(qrData.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('mineralType: $mineralType, ')
          ..write('voucherNumber: $voucherNumber, ')
          ..write('mineralValue: $mineralValue, ')
          ..write('quantity: $quantity, ')
          ..write('vehicleNumber: $vehicleNumber, ')
          ..write('transportPhone: $transportPhone, ')
          ..write('buyerName: $buyerName, ')
          ..write('destination: $destination, ')
          ..write('productionCenter: $productionCenter, ')
          ..write('sellerName: $sellerName, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('salesDate: $salesDate, ')
          ..write('qrData: $qrData, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReceiptsTable receipts = $ReceiptsTable(this);
  late final ReceiptsDao receiptsDao = ReceiptsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [receipts];
}

typedef $$ReceiptsTableCreateCompanionBuilder =
    ReceiptsCompanion Function({
      required String id,
      required String mineralType,
      required String voucherNumber,
      required String mineralValue,
      required String quantity,
      required String vehicleNumber,
      required String transportPhone,
      required String buyerName,
      required String destination,
      required String productionCenter,
      required String sellerName,
      required String licenseNumber,
      required DateTime salesDate,
      required String qrData,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReceiptsTableUpdateCompanionBuilder =
    ReceiptsCompanion Function({
      Value<String> id,
      Value<String> mineralType,
      Value<String> voucherNumber,
      Value<String> mineralValue,
      Value<String> quantity,
      Value<String> vehicleNumber,
      Value<String> transportPhone,
      Value<String> buyerName,
      Value<String> destination,
      Value<String> productionCenter,
      Value<String> sellerName,
      Value<String> licenseNumber,
      Value<DateTime> salesDate,
      Value<String> qrData,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ReceiptsTableFilterComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mineralType => $composableBuilder(
    column: $table.mineralType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voucherNumber => $composableBuilder(
    column: $table.voucherNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mineralValue => $composableBuilder(
    column: $table.mineralValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transportPhone => $composableBuilder(
    column: $table.transportPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buyerName => $composableBuilder(
    column: $table.buyerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productionCenter => $composableBuilder(
    column: $table.productionCenter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sellerName => $composableBuilder(
    column: $table.sellerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get salesDate => $composableBuilder(
    column: $table.salesDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrData => $composableBuilder(
    column: $table.qrData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReceiptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mineralType => $composableBuilder(
    column: $table.mineralType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voucherNumber => $composableBuilder(
    column: $table.voucherNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mineralValue => $composableBuilder(
    column: $table.mineralValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transportPhone => $composableBuilder(
    column: $table.transportPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buyerName => $composableBuilder(
    column: $table.buyerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productionCenter => $composableBuilder(
    column: $table.productionCenter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sellerName => $composableBuilder(
    column: $table.sellerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get salesDate => $composableBuilder(
    column: $table.salesDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrData => $composableBuilder(
    column: $table.qrData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReceiptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceiptsTable> {
  $$ReceiptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mineralType => $composableBuilder(
    column: $table.mineralType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voucherNumber => $composableBuilder(
    column: $table.voucherNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mineralValue => $composableBuilder(
    column: $table.mineralValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get vehicleNumber => $composableBuilder(
    column: $table.vehicleNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transportPhone => $composableBuilder(
    column: $table.transportPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get buyerName =>
      $composableBuilder(column: $table.buyerName, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get productionCenter => $composableBuilder(
    column: $table.productionCenter,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sellerName => $composableBuilder(
    column: $table.sellerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get licenseNumber => $composableBuilder(
    column: $table.licenseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get salesDate =>
      $composableBuilder(column: $table.salesDate, builder: (column) => column);

  GeneratedColumn<String> get qrData =>
      $composableBuilder(column: $table.qrData, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReceiptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReceiptsTable,
          Receipt,
          $$ReceiptsTableFilterComposer,
          $$ReceiptsTableOrderingComposer,
          $$ReceiptsTableAnnotationComposer,
          $$ReceiptsTableCreateCompanionBuilder,
          $$ReceiptsTableUpdateCompanionBuilder,
          (Receipt, BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>),
          Receipt,
          PrefetchHooks Function()
        > {
  $$ReceiptsTableTableManager(_$AppDatabase db, $ReceiptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceiptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceiptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceiptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> mineralType = const Value.absent(),
                Value<String> voucherNumber = const Value.absent(),
                Value<String> mineralValue = const Value.absent(),
                Value<String> quantity = const Value.absent(),
                Value<String> vehicleNumber = const Value.absent(),
                Value<String> transportPhone = const Value.absent(),
                Value<String> buyerName = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<String> productionCenter = const Value.absent(),
                Value<String> sellerName = const Value.absent(),
                Value<String> licenseNumber = const Value.absent(),
                Value<DateTime> salesDate = const Value.absent(),
                Value<String> qrData = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReceiptsCompanion(
                id: id,
                mineralType: mineralType,
                voucherNumber: voucherNumber,
                mineralValue: mineralValue,
                quantity: quantity,
                vehicleNumber: vehicleNumber,
                transportPhone: transportPhone,
                buyerName: buyerName,
                destination: destination,
                productionCenter: productionCenter,
                sellerName: sellerName,
                licenseNumber: licenseNumber,
                salesDate: salesDate,
                qrData: qrData,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String mineralType,
                required String voucherNumber,
                required String mineralValue,
                required String quantity,
                required String vehicleNumber,
                required String transportPhone,
                required String buyerName,
                required String destination,
                required String productionCenter,
                required String sellerName,
                required String licenseNumber,
                required DateTime salesDate,
                required String qrData,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReceiptsCompanion.insert(
                id: id,
                mineralType: mineralType,
                voucherNumber: voucherNumber,
                mineralValue: mineralValue,
                quantity: quantity,
                vehicleNumber: vehicleNumber,
                transportPhone: transportPhone,
                buyerName: buyerName,
                destination: destination,
                productionCenter: productionCenter,
                sellerName: sellerName,
                licenseNumber: licenseNumber,
                salesDate: salesDate,
                qrData: qrData,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReceiptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReceiptsTable,
      Receipt,
      $$ReceiptsTableFilterComposer,
      $$ReceiptsTableOrderingComposer,
      $$ReceiptsTableAnnotationComposer,
      $$ReceiptsTableCreateCompanionBuilder,
      $$ReceiptsTableUpdateCompanionBuilder,
      (Receipt, BaseReferences<_$AppDatabase, $ReceiptsTable, Receipt>),
      Receipt,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db, _db.receipts);
}
