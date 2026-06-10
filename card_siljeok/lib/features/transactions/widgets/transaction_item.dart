import 'package:flutter/material.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/core/theme/app_colors.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionItem({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.description.isNotEmpty ? transaction.description : transaction.category,
                style: AppTypography.bodyLg.copyWith(
                  color: transaction.isExcluded ? cs.onSurfaceVariant.withValues(alpha: 0.5) : cs.onSurfaceVariant,
                  decoration: transaction.isExcluded ? TextDecoration.lineThrough : null,
                ),
              ),
              if (transaction.isExcluded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('제외', style: AppTypography.bodySm.copyWith(color: AppColors.error)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('\${transaction.amount.toStringAsFixed(0)}원', style: AppTypography.bodyLg.copyWith(color: transaction.isExcluded ? cs.secondary.withValues(alpha: 0.5) : cs.secondary)),
          const SizedBox(height: 4),
          Text('날짜: \${transaction.date.toLocal().toString().split(' ')[0]}', style: AppTypography.bodySm.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}
