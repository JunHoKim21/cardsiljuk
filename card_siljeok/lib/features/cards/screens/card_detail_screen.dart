import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/core/theme/app_colors.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/transactions/providers/transaction_provider.dart';
import 'package:card_siljeok/features/transactions/widgets/transaction_item.dart';
import 'package:card_siljeok/features/transactions/widgets/transaction_filter_widget.dart';
import 'package:card_siljeok/features/transactions/models/transaction_model.dart';
import 'package:card_siljeok/services/payment_api_service.dart';
import 'package:card_siljeok/features/analytics/providers/performance_provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CardDetailScreen extends ConsumerStatefulWidget {
  final CardModel card;
  const CardDetailScreen({super.key, required this.card});

  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> {
  DateTimeRange? _dateRange;
  String? _category;
  double? _minAmount;
  double? _maxAmount;
  bool _isProcessingPayment = false;

  Future<void> _processTestPayment() async {
    setState(() {
      _isProcessingPayment = true;
    });

    try {
      final paymentService = ref.read(paymentApiServiceProvider);
      // Simulate payment (using 50,000 as amount)
      await paymentService.processPayment(
        cardId: widget.card.id,
        amount: 50000,
        description: '카카오페이 송금',
        authToken: 'mock_token_123',
      );

      // On success, add transaction
      final newTransaction = TransactionModel(
        id: const Uuid().v4(),
        amount: 50000,
        category: '기타',
        date: DateTime.now(),
        status: '승인됨',
        cardId: widget.card.id,
        description: '카카오페이 송금',
      );

      await ref.read(transactionProvider.notifier).addTransaction(newTransaction);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('결제가 성공적으로 처리되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('결제 실패'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }

  void _openFilter() async {
    final result = await showModalBottomSheet<TransactionFilterResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => TransactionFilterWidget(
        initialDateRange: _dateRange,
        initialCategory: _category,
        initialMinAmount: _minAmount,
        initialMaxAmount: _maxAmount,
      ),
    );
    if (result != null) {
      setState(() {
        _dateRange = result.dateRange;
        _category = result.category;
        _minAmount = result.minAmount;
        _maxAmount = result.maxAmount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = ref.read(transactionProvider.notifier).filterTransactions(
          cardId: widget.card.id,
          dateRange: _dateRange,
          category: _category,
          minAmount: _minAmount,
          maxAmount: _maxAmount,
        );
    
    final perf = ref.watch(performanceProvider(widget.card.id));
    final numFormat = NumberFormat('#,###');

    return Scaffold(
      appBar: AppBar(
        title: Text('카드 상세', style: AppTypography.headlineLg.copyWith(color: cs.onSurface)),
        backgroundColor: cs.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt, color: cs.onSurfaceVariant),
            onPressed: _openFilter,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.card.cardName, style: AppTypography.headlineMd.copyWith(color: cs.onSurface)),
                    Text('**** ${widget.card.id.substring(widget.card.id.length - 4)}',
                        style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Performance Progress Bar
            Text('실적 달성 현황', style: AppTypography.headlineSm.copyWith(color: cs.onSurface)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.roundedMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('인정 실적', style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)),
                      Text('${numFormat.format(perf.recognizedAmount)}원', style: AppTypography.headlineSm.copyWith(color: cs.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: perf.achievementRate,
                    minHeight: 12,
                    backgroundColor: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(6),
                    valueColor: AlwaysStoppedAnimation<Color>(perf.achievementRate >= 1.0 ? AppColors.success : AppColors.primary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('목표: ${numFormat.format(perf.targetAmount)}원', style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                      if (perf.remainingAmount > 0)
                        Text('${numFormat.format(perf.remainingAmount)}원 남음', style: AppTypography.bodyMd.copyWith(color: AppColors.error))
                      else
                        Text('달성 완료!', style: AppTypography.bodyMd.copyWith(color: AppColors.success)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('거래 내역 (${filtered.length})', style: AppTypography.headlineSm.copyWith(color: cs.onSurface)),
            const SizedBox(height: 8),
            Expanded(
              child: filtered.isEmpty
                  ? Center(child: Text('거래가 없습니다.', style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)))
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => TransactionItem(transaction: filtered[index]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isProcessingPayment ? null : _processTestPayment,
        label: _isProcessingPayment 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Text('결제 테스트'),
        icon: _isProcessingPayment ? null : const Icon(Icons.payment),
      ),
    );
  }
}

class TransactionFilterResult {
  final DateTimeRange? dateRange;
  final String? category;
  final double? minAmount;
  final double? maxAmount;
  const TransactionFilterResult({this.dateRange, this.category, this.minAmount, this.maxAmount});
}
