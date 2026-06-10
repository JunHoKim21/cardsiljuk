import 'package:flutter/material.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/model/card_model.dart';

class CardItem extends StatelessWidget {
  final CardModel card;
  const CardItem({Key? key, required this.card}) : super(key: key);

  String _maskCardNumber(String id) {
    // Simple mask: show last 4 digits
    if (id.length <= 4) return id;
    return '•••• •••• •••• ${id.substring(id.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Row(
          children: [
            // Placeholder for card image/icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.credit_card, size: 28, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.stackGapMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.cardName, style: AppTypography.labelLg.copyWith(color: cs.onSurface)),
                  const SizedBox(height: 4),
                  Text(_maskCardNumber(card.id), style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('잔액: \\${card.amount.toStringAsFixed(0)}원', style: AppTypography.bodyMd.copyWith(color: cs.secondary)),
                      Text(card.category, style: AppTypography.labelSm.copyWith(color: cs.tertiary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
