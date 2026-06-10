import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/model/card_model.dart';

/// Hive box name for cards
const String _cardsBoxName = 'cards';

/// StateNotifier that holds a list of CardModel objects.
class CardProvider extends StateNotifier<List<CardModel>> {
  CardProvider() : super([]) {
    _loadCards();
  }

  /// Load cards from Hive when the provider is created.
  Future<void> _loadCards() async {
    final box = await Hive.openBox<CardModel>(_cardsBoxName);
    state = box.values.toList();
    // Listen for changes and update state accordingly.
    box.watch().listen((event) {
      state = box.values.toList();
    });
  }

  /// Add a new card and persist it.
  Future<void> addCard(CardModel card) async {
    final box = Hive.box<CardModel>(_cardsBoxName);
    await box.add(card);
    // State will be updated via the watcher.
  }

  /// Remove a card by its Hive key.
  Future<void> removeCard(int key) async {
    final box = Hive.box<CardModel>(_cardsBoxName);
    // Using index as key for simplicity; deletes card at given position.
    await box.deleteAt(key);
  }

  /// Update an existing card at the given key.
  Future<void> updateCard(int key, CardModel card) async {
    final box = Hive.box<CardModel>(_cardsBoxName);
    await box.put(key, card);
  }
}

/// Riverpod provider for the CardProvider.
final cardProvider = StateNotifierProvider<CardProvider, List<CardModel>>((ref) {
  return CardProvider();
});
