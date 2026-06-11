import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'package:uuid/uuid.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';

// Background message handler. Must be a top-level function.
@pragma('vm:entry-point')
backgroundMessageHandler(SmsMessage message) async {
  debugPrint('Background SMS received: ${message.body}');
  // Implement background parsing and storing here later
  // Since ProviderContainer isn't easily accessible here, we might just use SharedPreferences
  // or a Workmanager task to sync it later.
}

class SmsParserService {
  final Telephony telephony = Telephony.instance;

  Future<void> init(Function(TransactionModel) onTransactionParsed) async {
    bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != null && permissionsGranted) {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          debugPrint('Foreground SMS received: ${message.body}');
          _parseAndNotify(message.body ?? '', onTransactionParsed);
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
    }
  }

  void _parseAndNotify(String body, Function(TransactionModel) onTransactionParsed) {
    final transaction = parseSms(body);
    if (transaction != null) {
      onTransactionParsed(transaction);
    }
  }

  /// SMS parsing logic using Regex for major Korean card companies
  TransactionModel? parseSms(String body) {
    // Example: "[Web발신] 삼성카드 승인 홍길동님 50,000원 12/25 14:30 (주)우아한형제들 누적 150,000원"
    // Example: "KB국민카드(1*3*) 홍길동님 06/11 12:30 15,000원 스타벅스 승인"
    
    // Very basic heuristic parser for demonstration
    // In production, each card company requires specific regex patterns.
    if (!body.contains('카드') && !body.contains('승인') && !body.contains('원')) {
      return null;
    }

    String description = '알 수 없는 가맹점';
    double amount = 0;
    
    // Extract amount
    final amountMatch = RegExp(r'([0-9,]+)원').firstMatch(body);
    if (amountMatch != null) {
      amount = double.tryParse(amountMatch.group(1)!.replaceAll(',', '')) ?? 0;
    }

    // Heuristic: Extract the word before "승인" or after the amount as description
    // This is highly simplified and will need robust regex per card company.
    final words = body.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].contains('원') && i + 1 < words.length) {
        if (!words[i+1].contains('누적') && !words[i+1].contains('잔액')) {
          description = words[i+1];
        }
      }
    }
    
    // If we couldn't parse amount, discard
    if (amount == 0) return null;

    return TransactionModel(
      id: const Uuid().v4(),
      cardId: 'sms_card_placeholder', // Requires mapping card name to cardId
      amount: amount,
      date: DateTime.now(),
      status: 'completed',
      description: description,
      category: '미분류',
      isExcluded: false,
    );
  }
}
