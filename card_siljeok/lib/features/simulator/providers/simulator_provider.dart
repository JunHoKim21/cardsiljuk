import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/features/analytics/providers/performance_provider.dart';
import 'package:card_siljeok/features/keyword_rule/keyword_rule_engine.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';

class SimulatorState {
  final double simulatedAmount;
  final String simulatedCategory;
  final String simulatedKeyword;
  final PerformanceState performanceAfter;
  final bool isAchievedNow;

  SimulatorState({
    required this.simulatedAmount,
    required this.simulatedCategory,
    required this.simulatedKeyword,
    required this.performanceAfter,
    required this.isAchievedNow,
  });
}

final simulatorProvider = StateNotifierProvider.family<SimulatorNotifier, SimulatorState?, String>((ref, cardId) {
  final currentPerf = ref.watch(performanceProvider(cardId));
  return SimulatorNotifier(currentPerf, ref);
});

class SimulatorNotifier extends StateNotifier<SimulatorState?> {
  final PerformanceState currentPerf;
  final Ref ref;

  SimulatorNotifier(this.currentPerf, this.ref) : super(null);

  Future<void> simulate(String cardId, double amount, String category, String keyword) async {
    // Check global exclusions
    final engine = ref.read(keywordRuleEngineProvider.notifier);
    final isExcludedGlobally = engine.check(keyword);
    
    // Check card exclusions
    final cards = ref.read(cardProvider);
    final targetCard = cards.firstWhere((c) => c.id == cardId, orElse: () => cards.first);
    final excludedByCategory = targetCard.excludedCategories.contains(category);

    double recognizedAdd = amount;
    if (isExcludedGlobally || excludedByCategory) {
      recognizedAdd = 0;
    }

    final newRecognized = currentPerf.recognizedAmount + recognizedAdd;
    final newAchievementRate = currentPerf.targetAmount > 0 ? (newRecognized / currentPerf.targetAmount).clamp(0.0, 1.0) : 0.0;
    final newRemaining = currentPerf.targetAmount > newRecognized ? currentPerf.targetAmount - newRecognized : 0.0;

    final performanceAfter = PerformanceState(
      recognizedAmount: newRecognized,
      targetAmount: currentPerf.targetAmount,
      achievementRate: newAchievementRate,
      remainingAmount: newRemaining,
    );

    state = SimulatorState(
      simulatedAmount: amount,
      simulatedCategory: category,
      simulatedKeyword: keyword,
      performanceAfter: performanceAfter,
      isAchievedNow: newRemaining == 0 && currentPerf.remainingAmount > 0,
    );
  }
  
  void clear() {
    state = null;
  }
}
