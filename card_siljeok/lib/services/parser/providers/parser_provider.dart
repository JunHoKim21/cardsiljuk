import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/services/parser/sms_parser_service.dart';
import 'package:card_siljeok/services/parser/notification_parser_service.dart';
import 'package:card_siljeok/features/transactions/providers/transaction_provider.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';
import 'package:card_siljeok/services/notification/local_notification_service.dart';
import 'package:flutter/material.dart';

final parserProvider = Provider<ParserManager>((ref) {
  return ParserManager(ref);
});

class ParserManager {
  final Ref ref;
  final SmsParserService smsParser = SmsParserService();
  final NotificationParserService notifParser = NotificationParserService();

  ParserManager(this.ref);

  Future<void> initialize() async {
    // Initialize SMS Listener
    await smsParser.init((transaction) {
      _handleParsedTransaction(transaction);
    });

    // Initialize Notification Listener
    await notifParser.init((transaction) {
      _handleParsedTransaction(transaction);
    });
  }

  void _handleParsedTransaction(TransactionModel transaction) {
    debugPrint('New Transaction Parsed: ${transaction.amount} / ${transaction.description}');
    
    // Auto-match card if possible. Here we just assign the first card for demo purposes.
    // In production, we'd check if the transaction text contains the card name/number.
    final cards = ref.read(cardProvider);
    if (cards.isNotEmpty) {
      final matchedCard = cards.first; // Simplified
      final finalTransaction = transaction.copyWith(cardId: matchedCard.id);
      ref.read(transactionProvider.notifier).addTransaction(finalTransaction);
      debugPrint('Transaction mapped to card ${matchedCard.cardName} and saved.');

      // Push Notification
      LocalNotificationService().showNotification(
        id: transaction.id.hashCode,
        title: '새로운 카드 실적 내역 자동 등록',
        body: '${matchedCard.cardName} 카드로 ${transaction.amount}원 결제 내역이 반영되었습니다.',
      );

    } else {
      debugPrint('No cards registered. Cannot save parsed transaction.');
    }
  }
}
