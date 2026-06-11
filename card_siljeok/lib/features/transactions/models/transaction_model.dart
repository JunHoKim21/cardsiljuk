// GENERATED CODE - placeholder for TransactionModel
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String status;
  @HiveField(5)
  final String cardId;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final bool isExcluded;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.status,
    required this.cardId,
    this.description = '',
    this.isExcluded = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'status': status,
      'cardId': cardId,
      'description': description,
      'isExcluded': isExcluded,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      amount: (map['amount'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? '',
      cardId: map['cardId'] ?? '',
      description: map['description'] ?? '',
      isExcluded: map['isExcluded'] ?? false,
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    String? status,
    String? cardId,
    String? description,
    bool? isExcluded,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      status: status ?? this.status,
      cardId: cardId ?? this.cardId,
      description: description ?? this.description,
      isExcluded: isExcluded ?? this.isExcluded,
    );
  }
}
