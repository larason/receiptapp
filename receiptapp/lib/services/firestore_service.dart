import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/app_constants.dart';
import '../models/receipt.dart';

/// Data access layer for the `receipts` Firestore collection.
///
/// This is the only class that talks directly to Firestore; providers and
/// screens go through it.
class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _receipts =>
      _firestore.collection(AppConstants.receiptsCollection);

  /// Creates a new receipt document and returns its id.
  ///
  /// `createdAt` and `updatedAt` are stamped by the Firestore server.
  Future<String> createReceipt(Receipt receipt) async {
    final docRef = _receipts.doc();
    await docRef.set({
      ...receipt.toMap(),
      'id': docRef.id,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  /// Fetches all receipts, newest first.
  Future<List<Receipt>> fetchReceipts() async {
    final snapshot = await _receipts
        .orderBy('salesDate', descending: true)
        .get();
    return _mapDocs(snapshot);
  }

  /// Streams all receipts, newest first, updating on every change.
  Stream<List<Receipt>> watchReceipts() {
    return _receipts
        .orderBy('salesDate', descending: true)
        .snapshots()
        .map(_mapDocs);
  }

  /// Updates an existing receipt. Requires a non-null [Receipt.id].
  Future<void> updateReceipt(Receipt receipt) async {
    final id = receipt.id;
    if (id == null) {
      throw ArgumentError('Cannot update a receipt without an id.');
    }
    await _receipts.doc(id).update({
      ...receipt.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Deletes the receipt document with [id].
  Future<void> deleteReceipt(String id) async {
    await _receipts.doc(id).delete();
  }

  List<Receipt> _mapDocs(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => Receipt.fromMap(doc.data(), id: doc.id))
        .toList();
  }
}
