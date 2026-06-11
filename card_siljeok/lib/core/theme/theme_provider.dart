import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/theme/app_theme.dart';
import 'package:card_siljeok/features/main/screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:card_siljeok/l10n/app_localizations.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class ThemeProvider extends ConsumerWidget {
  const ThemeProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp(
      themeMode: mode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: child,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''), // Korean, no country code
        Locale('en', ''), // English, no country code
      ],
      routes: {
        '/home': (context) => const MainScreen(),
      },
    );
  }
}
