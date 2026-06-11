import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';
import 'core/theme/theme_provider.dart';
import 'features/main/screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'services/auth_service.dart';
import 'core/model/card_model.dart';
import 'features/transactions/models/transaction_model.dart';
import 'services/mock_data_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'features/sync/providers/sync_provider.dart';
import 'services/notification/local_notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // In background, we need to initialize Firebase or MyDataService
      // Note: Full Firebase init might be needed here if syncProvider writes to Firestore
      final container = ProviderContainer();
      final syncProv = container.read(syncProvider.notifier);
      await syncProv.performSync();
      container.dispose();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}

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
  
  // Firebase 초기화 (구동 전 flutterfire configure 필수)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error (Did you run flutterfire configure?): $e');
  }
  
  try {
    await LocalNotificationService().init();
  } catch (e) {
    debugPrint('Local Notification init error: $e');
  }

  await Hive.initFlutter();
  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  final keyString = await _getOrCreateEncryptionKey();
  final encryptionKey = base64Url.decode(keyString);

  await Hive.openBox<CardModel>('cards', encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox<TransactionModel>('transactions');

  await MockDataService.generateMockData();

  if (!kIsWeb) {
    try {
      Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
      Workmanager().registerPeriodicTask(
        "mydata_sync_task",
        "mydata_sync_periodic",
        frequency: const Duration(minutes: 15),
      );
    } catch (e) {
      debugPrint('Workmanager init error: $e');
    }
  }

  runApp(const ProviderScope(child: ThemeProvider(child: SiljeokMateApp())));
}

class SiljeokMateApp extends StatelessWidget {
  const SiljeokMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthWrapper();
  }
}

// Wrapper that decides whether to show AuthScreen or MainScreen based on authentication state
class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});
  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authService = AuthService();
    final canAuth = await authService.isDeviceSupported();
    if (canAuth && await authService.hasBiometrics()) {
      final success = await authService.authenticate();
      setState(() {
        _isAuthenticated = success;
        _isLoading = false;
      });
    } else {
      // No biometrics, fallback to PIN check (assume already set)
      final hasPin = await authService.hasStoredPin();
      setState(() {
        _isAuthenticated = hasPin;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_isAuthenticated) {
      return const MainScreen();
    } else {
      return const AuthScreen();
    }
  }
}


