// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '카드 실적 메이트';

  @override
  String get homeTab => '홈';

  @override
  String get transactionsTab => '내역';

  @override
  String get analyticsTab => '통계';

  @override
  String get cardsTab => '카드';

  @override
  String get settingsTab => '설정';

  @override
  String get syncSuccess => '동기화 완료';

  @override
  String get syncError => '동기화 실패';

  @override
  String get syncing => '동기화 중...';
}
