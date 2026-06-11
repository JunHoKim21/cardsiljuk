import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/theme/app_colors.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';
import 'package:card_siljeok/features/simulator/providers/simulator_provider.dart';
import 'package:intl/intl.dart';

class SimulatorScreen extends ConsumerStatefulWidget {
  const SimulatorScreen({super.key});

  @override
  ConsumerState<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends ConsumerState<SimulatorScreen> {
  String? _selectedCardId;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final numFormat = NumberFormat('#,###');

  @override
  void dispose() {
    _amountController.dispose();
    _keywordController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _runSimulation() {
    if (_selectedCardId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('카드를 선택해주세요.')));
      return;
    }
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('유효한 금액을 입력해주세요.')));
      return;
    }

    ref.read(simulatorProvider(_selectedCardId!).notifier).simulate(
      _selectedCardId!,
      amount,
      _categoryController.text,
      _keywordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cards = ref.watch(cardProvider);
    final simState = _selectedCardId != null ? ref.watch(simulatorProvider(_selectedCardId!)) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('실적 달성 시뮬레이터', style: AppTypography.headlineLg.copyWith(color: cs.onSurface)),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('결제 전 실적 확인하기', style: AppTypography.headlineSm),
            const SizedBox(height: AppSpacing.stackGapMd),
            
            // Card Selection
            DropdownButton<String>(
              isExpanded: true,
              hint: const Text('카드 선택'),
              value: _selectedCardId,
              items: cards.map((c) => DropdownMenuItem(value: c.id, child: Text(c.cardName))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCardId = val;
                });
                if (val != null) {
                  ref.read(simulatorProvider(val).notifier).clear();
                }
              },
            ),
            const SizedBox(height: AppSpacing.stackGapMd),

            // Inputs
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: '결제 예상 금액 (원)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.stackGapMd),
            
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: '가맹점 카테고리 (예: 관리비)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.stackGapMd),
            
            TextField(
              controller: _keywordController,
              decoration: const InputDecoration(labelText: '결제 키워드 (예: 세금)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.stackGapLg),

            ElevatedButton(
              onPressed: _runSimulation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('시뮬레이션 실행', style: AppTypography.labelLg),
            ),

            const SizedBox(height: AppSpacing.stackGapLg),
            
            // Results
            if (simState != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.containerPadding),
                decoration: BoxDecoration(
                  color: simState.isAchievedNow ? AppColors.success.withValues(alpha: 0.1) : cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: simState.isAchievedNow ? AppColors.success : cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('시뮬레이션 결과', style: AppTypography.headlineSm.copyWith(color: cs.onSurface)),
                    const SizedBox(height: 16),
                    _ResultRow('결제 금액', '${numFormat.format(simState.simulatedAmount)}원'),
                    _ResultRow('실제 인정 금액', '${numFormat.format(simState.performanceAfter.recognizedAmount - (simState.performanceAfter.recognizedAmount - simState.simulatedAmount))}원'), // Simplified display
                    const Divider(),
                    _ResultRow('현재 총 인정 실적', '${numFormat.format(simState.performanceAfter.recognizedAmount)}원'),
                    _ResultRow('실적 달성률', '${(simState.performanceAfter.achievementRate * 100).toStringAsFixed(1)}%'),
                    const SizedBox(height: 16),
                    if (simState.isAchievedNow)
                      Row(
                        children: [
                          const Icon(Icons.celebration, color: AppColors.success),
                          const SizedBox(width: 8),
                          Expanded(child: Text('축하합니다! 이 결제로 목표 실적을 달성하게 됩니다.', style: AppTypography.bodyLg.copyWith(color: AppColors.success, fontWeight: FontWeight.bold))),
                        ],
                      )
                    else if (simState.performanceAfter.remainingAmount > 0)
                      Text('실적 달성까지 ${numFormat.format(simState.performanceAfter.remainingAmount)}원 남았습니다.', style: AppTypography.bodyMd.copyWith(color: AppColors.error))
                    else
                      Text('이미 실적을 달성한 상태입니다.', style: AppTypography.bodyMd.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  const _ResultRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMd.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          Text(value, style: AppTypography.labelLg.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        ],
      ),
    );
  }
}
