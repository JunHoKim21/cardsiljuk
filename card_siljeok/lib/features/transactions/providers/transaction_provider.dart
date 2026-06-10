import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../../keyword_rule/keyword_rule_engine.dart';

/// Hive box name for transactions
const String _transactionsBoxName = 'transactions';

class TransactionProvider extends StateNotifier<List<TransactionModel>> {
  final Ref ref;
  TransactionProvider(this.ref) : super([]) {
    _loadTransactions();
  }

  // Load transactions from Hive when provider is created
  Future<void> _loadTransactions() async {
    final box = await Hive.openBox<TransactionModel>(_transactionsBoxName);
    state = box.values.toList();
    // Listen for changes and update state accordingly.
    box.watch().listen((event) {
      state = box.values.toList();
    });
  }

  /// Add a new transaction and persist it.
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

    final box = Hive.box<TransactionModel>(_transactionsBoxName);
    await box.add(finalTransaction);
    // State will be updated via watcher.
  }

  /// Remove a transaction by its Hive key.
  Future<void> removeTransaction(int key) async {
    final box = Hive.box<TransactionModel>(_transactionsBoxName);
    await box.delete(key);
  }

  /// Update an existing transaction at the given key.
  Future<void> updateTransaction(int key, TransactionModel transaction) async {
    final box = Hive.box<TransactionModel>(_transactionsBoxName);
    await box.put(key, transaction);
  }

  /// Get transactions filtered by optional criteria.
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

/// Riverpod provider for the TransactionProvider.
final transactionProvider = StateNotifierProvider<TransactionProvider, List<TransactionModel>>((ref) {
  return TransactionProvider(ref);
});
