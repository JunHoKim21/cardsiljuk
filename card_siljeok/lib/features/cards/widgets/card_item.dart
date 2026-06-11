import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/core/theme/app_colors.dart';
import 'package:card_siljeok/features/analytics/providers/performance_provider.dart';
import 'package:intl/intl.dart';

class CardItem extends ConsumerWidget {
  final CardModel card;
  const CardItem({super.key, required this.card});

  String _maskCardNumber(String id) {
    if (id.length <= 4) return id;
    return '•••• •••• •••• ${id.substring(id.length - 4)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final perf = ref.watch(performanceProvider(card.id));
    final numFormat = NumberFormat('#,###');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Row(
          children: [
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
                  const SizedBox(height: 12),
                  // Progress Bar for Performance
                  LinearProgressIndicator(
                    value: perf.achievementRate,
                    minHeight: 6,
                    backgroundColor: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                    valueColor: AlwaysStoppedAnimation<Color>(perf.achievementRate >= 1.0 ? AppColors.success : AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${numFormat.format(perf.recognizedAmount)}원 달성', style: AppTypography.bodyMd.copyWith(color: cs.primary, fontWeight: FontWeight.bold)),
                      if (perf.remainingAmount > 0)
                        Text('${numFormat.format(perf.remainingAmount)}원 남음', style: AppTypography.labelSm.copyWith(color: AppColors.error))
                      else
                        Text('달성 완료!', style: AppTypography.labelSm.copyWith(color: AppColors.success)),
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
