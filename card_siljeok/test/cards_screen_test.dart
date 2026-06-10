import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/cards/screens/cards_screen.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CardModelAdapter());
    await Hive.openBox<CardModel>('cards');
  });

  tearDownAll(() async {
    await Hive.box<CardModel>('cards').clear();
    await Hive.close();
  });

  testWidgets('CardsScreen shows empty state when no cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CardsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('등록된 카드가 없습니다.'), findsOneWidget);
  });
}
