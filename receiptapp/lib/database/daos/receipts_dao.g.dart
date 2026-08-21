// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipts_dao.dart';

// ignore_for_file: type=lint
mixin _$ReceiptsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReceiptsTable get receipts => attachedDatabase.receipts;
  ReceiptsDaoManager get managers => ReceiptsDaoManager(this);
}

class ReceiptsDaoManager {
  final _$ReceiptsDaoMixin _db;
  ReceiptsDaoManager(this._db);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db.attachedDatabase, _db.receipts);
}
