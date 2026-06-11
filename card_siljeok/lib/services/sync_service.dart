import 'package:card_siljeok/services/firestore_service.dart';
import 'package:hive/hive.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SyncService {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> migrateLocalDataToFirestore() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cardsBox = Hive.box<CardModel>('cards');
    final txBox = Hive.box<TransactionModel>('transactions');

    final batch = _db.batch();

    final userCardsRef = _db.collection('users').doc(uid).collection('cards');
    for (var card in cardsBox.values) {
      final docRef = userCardsRef.doc(card.id);
      batch.set(docRef, {
        'id': card.id,
        'cardName': card.cardName,
        'amount': card.amount,
        'date': card.date.toIso8601String(),
        'category': card.category,
      });
    }

    final userTxRef = _db.collection('users').doc(uid).collection('transactions');
    for (var tx in txBox.values) {
      final docRef = userTxRef.doc(tx.id);
      batch.set(docRef, {
        'id': tx.id,
        'cardId': tx.cardId,
        'amount': tx.amount,
        'date': tx.date.toIso8601String(),
        'category': tx.category,
        'status': tx.status,
        'description': tx.description,
        'isExcluded': tx.isExcluded,
      });
    }

    await batch.commit();

    // Clear local data after migration (Optional: we can keep it as cache later)
    await cardsBox.clear();
    await txBox.clear();
  }
}
