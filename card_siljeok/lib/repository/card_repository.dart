import 'package:hive/hive.dart';
import '../core/model/card_model.dart';

class CardRepository {
  static final CardRepository _instance = CardRepository._internal();
  factory CardRepository() => _instance;
  CardRepository._internal();

  late Box<CardModel> _box;

  Future<void> init() async {
    _box = Hive.box<CardModel>('cards');
  }

  Future<void> addCard(CardModel card) async {
    await _box.put(card.id, card);
  }

  List<CardModel> getAllCards() {
    return _box.values.toList();
  }

  Future<void> deleteCard(String id) async {
    await _box.delete(id);
  }
}
