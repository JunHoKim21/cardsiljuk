import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/features/cards/screens/card_detail_screen.dart';
import 'package:card_siljeok/features/cards/screens/add_card_screen.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';
import 'package:card_siljeok/features/cards/widgets/card_item.dart';

class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardProvider);
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('카드 관리', style: AppTypography.headlineLg.copyWith(color: cs.onSurface)),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: cards.isEmpty
            ? Center(child: Text('등록된 카드가 없습니다.', style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)))
            : ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => CardDetailScreen(card: card)));
                    },
                    child: Dismissible(
                      key: ValueKey(card.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        ref.read(cardProvider.notifier).removeCard(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('카드가 삭제되었습니다')),
                        );
                      },
                      child: CardItem(card: card),
                    ),
                  );
                }
              ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddCardScreen()));
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}
