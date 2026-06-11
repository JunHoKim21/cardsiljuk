import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/transactions/providers/transaction_provider.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';

class PerformanceState {
  final double recognizedAmount;
  final double targetAmount;
  final double remainingAmount;
  final double achievementRate;

  PerformanceState({
    required this.recognizedAmount,
    required this.targetAmount,
    required this.remainingAmount,
    required this.achievementRate,
  });
}

// 특정 카드의 실적 상태를 계산해서 제공하는 Provider (파생 상태)
final performanceProvider = Provider.family<PerformanceState, String>((ref, cardId) {
  final transactions = ref.watch(transactionProvider);
  final cards = ref.watch(cardProvider);
  
  final card = cards.firstWhere((c) => c.id == cardId, orElse: () => CardModel(id: '', cardName: '', amount: 0, date: DateTime.now(), category: ''));
  if (card.id.isEmpty) {
    return PerformanceState(recognizedAmount: 0, targetAmount: 0, remainingAmount: 0, achievementRate: 0);
  }

  final cardTxs = transactions.where((t) => t.cardId == cardId).toList();
  double recognized = 0.0;
  
  final now = DateTime.now();
  for (final tx in cardTxs) {
    if (tx.date.year == now.year && tx.date.month == now.month) {
      if (!tx.isExcluded) {
        if (!card.excludedCategories.contains(tx.category)) {
          recognized += tx.amount;
        }
      }
    }
  }

  final target = card.targetAmount;
  final remaining = target > recognized ? target - recognized : 0.0;
  final rate = target > 0 ? (recognized / target).clamp(0.0, 1.0) : 0.0;

  return PerformanceState(
    recognizedAmount: recognized,
    targetAmount: target,
    remainingAmount: remaining,
    achievementRate: rate,
  );
});
