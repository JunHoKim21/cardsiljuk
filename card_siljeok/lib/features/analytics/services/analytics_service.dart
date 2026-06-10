import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';

class AnalyticsService {
  /// 카테고리별 지출 금액 합계를 계산합니다 (제외된 항목은 무시)
  Map<String, double> calculateCategorySpend(List<TransactionModel> transactions) {
    final Map<String, double> categorySpend = {};

    for (final t in transactions) {
      if (t.isExcluded) continue; // 제외된 내역 무시
      
      final currentAmount = categorySpend[t.category] ?? 0.0;
      categorySpend[t.category] = currentAmount + t.amount;
    }

    return categorySpend;
  }
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});
