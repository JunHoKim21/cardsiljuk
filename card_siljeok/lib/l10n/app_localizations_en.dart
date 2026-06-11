// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Card Siljeok Mate';

  @override
  String get homeTab => 'Home';

  @override
  String get transactionsTab => 'History';

  @override
  String get analyticsTab => 'Analytics';

  @override
  String get cardsTab => 'Cards';

  @override
  String get settingsTab => 'Settings';

  @override
  String get syncSuccess => 'Sync Complete';

  @override
  String get syncError => 'Sync Failed';

  @override
  String get syncing => 'Syncing...';
}
