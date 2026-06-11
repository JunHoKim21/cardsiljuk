import 'package:flutter/material.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import 'package:uuid/uuid.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';

class NotificationParserService {
  Future<void> init(Function(TransactionModel) onTransactionParsed) async {
    debugPrint('Initializing Notification Listener...');
    
    // Check permission
    bool status = await NotificationListenerService.isPermissionGranted();
    if (!status) {
      debugPrint('Notification Permission not granted. Requesting...');
      status = await NotificationListenerService.requestPermission();
    }

    if (status) {
      debugPrint('Notification Permission granted. Listening to events...');
      NotificationListenerService.notificationsStream.listen((event) {
        debugPrint('Notification received: ${event.packageName} - ${event.title}');
        
        // Target specific packages (e.g., KakaoTalk, Toss, Card apps)
        if (event.packageName == 'com.kakao.talk' || event.packageName?.contains('card') == true) {
          _parseAndNotify(event, onTransactionParsed);
        }
      });
    }
  }

  void _parseAndNotify(ServiceNotificationEvent event, Function(TransactionModel) onTransactionParsed) {
    final transaction = parseNotification(event);
    if (transaction != null) {
      onTransactionParsed(transaction);
    }
  }

  TransactionModel? parseNotification(ServiceNotificationEvent event) {
    final title = event.title ?? '';
    final content = event.content ?? '';
    final fullText = '$title $content';

    // Heuristic parsing for Kakao/Toss/Card push notifications
    if (!fullText.contains('원') || (!fullText.contains('승인') && !fullText.contains('결제'))) {
      return null;
    }

    double amount = 0;
    final amountMatch = RegExp(r'([0-9,]+)원').firstMatch(fullText);
    if (amountMatch != null) {
      amount = double.tryParse(amountMatch.group(1)!.replaceAll(',', '')) ?? 0;
    }

    if (amount == 0) return null;

    return TransactionModel(
      id: const Uuid().v4(),
      cardId: 'push_card_placeholder', // Should be matched to user's card
      amount: amount,
      date: DateTime.now(),
      status: 'completed',
      description: title.isNotEmpty ? title : '푸시 결제 내역',
      category: '미분류',
      isExcluded: false,
    );
  }
}
