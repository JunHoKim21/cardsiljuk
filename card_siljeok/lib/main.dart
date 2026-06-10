import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'core/theme/theme_provider.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'core/model/card_model.dart';
import 'features/transactions/models/transaction_model.dart';
import 'services/mock_data_service.dart';

Future<String> _getOrCreateEncryptionKey() async {
  const storage = FlutterSecureStorage();
  String? key = await storage.read(key: 'hiveEncryptionKey');
  if (key == null) {
    final rand = Random.secure();
    final bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    key = base64UrlEncode(bytes);
    await storage.write(key: 'hiveEncryptionKey', value: key);
  }
  return key;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());
  
  final keyString = await _getOrCreateEncryptionKey();
  final encryptionKey = base64Url.decode(keyString);
  
  await Hive.openBox<CardModel>('cards', encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox<TransactionModel>('transactions');
  
  await MockDataService.generateMockData();

  runApp(const ProviderScope(child: ThemeProvider(child: SiljeokMateApp())));
}

class SiljeokMateApp extends StatelessWidget {
  const SiljeokMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingScreen();
  }
}
