import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../../keyword_rule/keyword_rule_engine.dart';
import '../../../services/firestore_service.dart';

class TransactionProvider extends StateNotifier<List<TransactionModel>> {
  final Ref ref;
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<TransactionModel>>? _subscription;

  TransactionProvider(this.ref) : super([]) {
    _init();
  }

  void _init() {
    _subscription = _firestoreService.streamTransactions().listen((transactions) {
      state = transactions;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final engine = ref.read(keywordRuleEngineProvider.notifier);
    final isExcluded = engine.check(transaction.description);
    
    final finalTransaction = TransactionModel(
      id: transaction.id,
      amount: transaction.amount,
      category: transaction.category,
      date: transaction.date,
      status: transaction.status,
      cardId: transaction.cardId,
      description: transaction.description,
      isExcluded: isExcluded,
    );

    await _firestoreService.saveTransaction(finalTransaction);
  }

  Future<void> removeTransaction(int key) async {
    if (key >= 0 && key < state.length) {
      final id = state[key].id;
      await _firestoreService.deleteTransaction(id);
    }
  }

  Future<void> updateTransaction(int key, TransactionModel transaction) async {
    await _firestoreService.saveTransaction(transaction);
  }

  List<TransactionModel> filterTransactions({
    String? cardId,
    DateTimeRange? dateRange,
    String? category,
    double? minAmount,
    double? maxAmount,
  }) {
    return state.where((t) {
      if (cardId != null && t.cardId != cardId) return false;
      if (category != null && t.category != category) return false;
      if (minAmount != null && t.amount < minAmount) return false;
      if (maxAmount != null && t.amount > maxAmount) return false;
      if (dateRange != null) {
        if (t.date.isBefore(dateRange.start) || t.date.isAfter(dateRange.end)) {
          return false;
        }
      }
      return true;
    }).toList();
  }
}

final transactionProvider = StateNotifierProvider<TransactionProvider, List<TransactionModel>>((ref) {
  return TransactionProvider(ref);
});
