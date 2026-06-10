import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants.dart';

class MockDataService {
  static Future<void> generateMockData() async {
    if (!kEnableMockData) return;

    // 카드 데이터 목업
    final cardBox = Hive.box<CardModel>('cards');
    if (cardBox.isEmpty) {
      final mockCards = List.generate(3, (i) => CardModel(
        id: 'card_${i + 1}',
        cardName: '카드 ${i + 1}',
        amount: 2500000 - i * 500000,
        date: DateTime.now().add(Duration(days: 365 * (i + 1))),
        category: '카드',
      ));
      await cardBox.addAll(mockCards);
    }

    // 거래 데이터 목업
    final txBox = Hive.box<TransactionModel>('transactions');
    if (txBox.isEmpty) {
      final categories = ['식비', '교통', '쇼핑', '문화', '기타'];
      final now = DateTime.now();
      final mockTxs = List.generate(20, (i) => TransactionModel(
        id: 'tx_${i + 1}',
        amount: (10000 + i * 5000).toDouble(),
        date: now.subtract(Duration(days: i)),
        category: categories[i % categories.length],
        status: 'completed',
        cardId: 'card_${(i % 3) + 1}',
        description: '목업 거래 ${i + 1}',
        isExcluded: false,
      ));
      await txBox.addAll(mockTxs);
    }
  }
}
