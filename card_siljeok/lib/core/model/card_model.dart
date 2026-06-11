import 'package:hive/hive.dart';

part 'card_model.g.dart';

@HiveType(typeId: 0)
class CardModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cardName;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final double targetAmount;

  @HiveField(6)
  final List<String> excludedCategories;

  CardModel({
    required this.id,
    required this.cardName,
    required this.amount,
    required this.date,
    required this.category,
    this.targetAmount = 0.0,
    this.excludedCategories = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cardName': cardName,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'targetAmount': targetAmount,
      'excludedCategories': excludedCategories,
    };
  }

  factory CardModel.fromMap(Map<String, dynamic> map, String id) {
    return CardModel(
      id: id,
      cardName: map['cardName'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      category: map['category'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0.0).toDouble(),
      excludedCategories: List<String>.from(map['excludedCategories'] ?? []),
    );
  }
}
