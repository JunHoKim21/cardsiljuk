import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';
import 'package:card_siljeok/core/model/card_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get transactionsRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('transactions');
  }

  CollectionReference<Map<String, dynamic>>? get cardsRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('cards');
  }

  CollectionReference<Map<String, dynamic>>? get keywordsRef {
    final uid = currentUserId;
    if (uid == null) return null;
    return _db.collection('users').doc(uid).collection('keywords');
  }

  // --- Transactions ---

  Future<void> saveTransaction(TransactionModel tx) async {
    final ref = transactionsRef;
    if (ref == null) return;
    await ref.doc(tx.id).set(tx.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    final ref = transactionsRef;
    if (ref == null) return;
    await ref.doc(id).delete();
  }

  Stream<List<TransactionModel>> streamTransactions() {
    final ref = transactionsRef;
    if (ref == null) return Stream.value([]);
    
    return ref.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => TransactionModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // --- Cards ---

  Future<void> saveCard(CardModel card) async {
    final ref = cardsRef;
    if (ref == null) return;
    await ref.doc(card.id).set(card.toMap());
  }

  Future<void> deleteCard(String id) async {
    final ref = cardsRef;
    if (ref == null) return;
    await ref.doc(id).delete();
  }

  Stream<List<CardModel>> streamCards() {
    final ref = cardsRef;
    if (ref == null) return Stream.value([]);
    
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => CardModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  // --- Keywords ---

  Future<void> saveKeyword(String keyword) async {
    final ref = keywordsRef;
    if (ref == null) return;
    // We can use the keyword itself as the document ID since they should be unique
    await ref.doc(keyword).set({'text': keyword, 'createdAt': FieldValue.serverTimestamp()});
  }

  Future<void> deleteKeyword(String keyword) async {
    final ref = keywordsRef;
    if (ref == null) return;
    await ref.doc(keyword).delete();
  }

  Stream<List<String>> streamKeywords() {
    final ref = keywordsRef;
    if (ref == null) return Stream.value([]);
    
    return ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()['text'] as String).toList();
    });
  }
}
