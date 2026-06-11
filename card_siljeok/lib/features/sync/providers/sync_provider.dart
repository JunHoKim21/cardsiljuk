import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/services/mydata/my_data_service.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';
import 'package:card_siljeok/features/transactions/providers/transaction_provider.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';
import 'package:card_siljeok/features/keyword_rule/keyword_rule_engine.dart';
import 'package:uuid/uuid.dart';

enum SyncState { idle, syncing, success, error }

class SyncStateModel {
  final SyncState state;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  SyncStateModel({
    required this.state,
    this.errorMessage,
    this.lastSyncTime,
  });

  SyncStateModel copyWith({
    SyncState? state,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return SyncStateModel(
      state: state ?? this.state,
      errorMessage: errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class SyncProvider extends StateNotifier<SyncStateModel> {
  final Ref ref;
  final MyDataService _myDataService = MyDataService();

  SyncProvider(this.ref) : super(SyncStateModel(state: SyncState.idle));

  Future<void> performSync() async {
    if (state.state == SyncState.syncing) return;
    state = state.copyWith(state: SyncState.syncing, errorMessage: null);

    try {
      // 1. Authenticate with MyData
      await _myDataService.fetchAccessToken();

      // 2. Fetch Cards
      final cardsData = await _myDataService.fetchCardList();
      final cardProv = ref.read(cardProvider.notifier);
      
      for (var cardMap in cardsData) {
        final card = CardModel(
          id: cardMap['cardId'] ?? const Uuid().v4(),
          cardName: cardMap['cardName'] ?? 'Unknown',
          amount: 0.0, // Mock initial amount
          date: DateTime.now(),
          category: 'Default',
        );
        // Note: in a real app, check if exists before adding, or update it
        // Since we mock, let's just add or catch duplicates. For now, just add.
        await cardProv.addCard(card);

        // 3. Fetch Transactions for this card
        final txData = await _myDataService.fetchTransactionHistory(card.id);
        final txProv = ref.read(transactionProvider.notifier);
        final ruleEngine = ref.read(keywordRuleEngineProvider.notifier);

        for (var txMap in txData) {
          final desc = txMap['description'] ?? '';
          final cat = txMap['category'] ?? '';
          
          final tx = TransactionModel(
            id: txMap['id'] ?? const Uuid().v4(),
            amount: (txMap['amount'] as num?)?.toDouble() ?? 0.0,
            category: cat,
            date: txMap['date'] != null ? DateTime.parse(txMap['date']) : DateTime.now(),
            status: txMap['status'] ?? 'APPROVED',
            cardId: card.id,
            description: desc,
            isExcluded: ruleEngine.check(desc, category: cat),
          );
          await txProv.addTransaction(tx);
        }
      }

      state = state.copyWith(
        state: SyncState.success,
        lastSyncTime: DateTime.now(),
      );
    } catch (e) {
      state = state.copyWith(
        state: SyncState.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final syncProvider = StateNotifierProvider<SyncProvider, SyncStateModel>((ref) {
  return SyncProvider(ref);
});
