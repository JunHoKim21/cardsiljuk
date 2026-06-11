import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/model/card_model.dart';
import '../../../services/firestore_service.dart';

class CardProvider extends StateNotifier<List<CardModel>> {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<CardModel>>? _subscription;

  CardProvider() : super([]) {
    _init();
  }

  void _init() {
    _subscription = _firestoreService.streamCards().listen((cards) {
      state = cards;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> addCard(CardModel card) async {
    await _firestoreService.saveCard(card);
  }

  Future<void> removeCard(int key) async {
    // Note: We need to use String ID now, not integer index.
    // However, the signature is int key. 
    // We can get the ID by index for backward compatibility:
    if (key >= 0 && key < state.length) {
      final id = state[key].id;
      await _firestoreService.deleteCard(id);
    }
  }

  Future<void> updateCard(int key, CardModel card) async {
    // The key here was index in Hive. We will just use the card.id directly to update in Firestore.
    await _firestoreService.saveCard(card);
  }
}

final cardProvider = StateNotifierProvider<CardProvider, List<CardModel>>((ref) {
  return CardProvider();
});
