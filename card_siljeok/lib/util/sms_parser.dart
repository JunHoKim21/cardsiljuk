import 'package:telephony/telephony.dart';
import '../repository/card_repository.dart';
import '../core/model/card_model.dart';
import 'package:uuid/uuid.dart';

class SmsParser {
  final Telephony _telephony = Telephony.instance;
  final CardRepository _repo = CardRepository();

  // Example regex patterns per card company (simplified)
  final Map<String, RegExp> _patterns = {
    '현대카드': RegExp(r'(\d{1,3},?\d{3})원\s*-(.*)\s*\[(\d{4}\.\d{2}\.\d{2})\]'),
    '신한카드': RegExp(r'([\d,]+)원\s*\-\s*(.*)\s*\[(\d{4}\/\d{2}\/\d{2})\]'),
    // Add more patterns as needed
  };

  Future<void> init() async {
    bool? permissionsGranted = await _telephony.requestPhoneAndSmsPermissions;
    if (permissionsGranted != true) return;
    _telephony.listenIncomingSms(onNewMessage: _onMessage);
  }

  void _onMessage(SmsMessage message) {
    final body = message.body ?? '';
    for (final entry in _patterns.entries) {
      final match = entry.value.firstMatch(body);
      if (match != null) {
        final amountStr = match.group(1)!.replaceAll(',', '');
        final amount = double.tryParse(amountStr) ?? 0.0;
        final description = match.group(2)!.trim();
        final dateStr = match.group(3)!;
        DateTime date;
        try {
          // support both YYYY.MM.DD and YYYY/MM/DD
          date = DateTime.parse(dateStr.replaceAll('.', '-'));
        } catch (_) {
          date = DateTime.now();
        }
        final card = CardModel(
          id: Uuid().v4(),
          cardName: entry.key,
          amount: amount,
          date: date,
          category: description,
        );
        _repo.addCard(card);
        break;
      }
    }
  }
}
