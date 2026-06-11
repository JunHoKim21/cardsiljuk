import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/features/transactions/providers/transaction_provider.dart';
import 'package:card_siljeok/features/transactions/widgets/transaction_item.dart';
import 'package:card_siljeok/features/analytics/services/analytics_service.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int touchedIndex = -1;

  final List<Color> colorPalette = [
    Colors.blueAccent,
    Colors.redAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.cyanAccent,
  ];

  void _showCategoryTransactions(String category) {
    final allTransactions = ref.read(transactionProvider);
    final filtered = allTransactions.where((t) => t.category == category && !t.isExcluded).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            final cs = Theme.of(context).colorScheme;
            return Container(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$category 내역', style: AppTypography.headlineSm.copyWith(color: cs.onSurface)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return TransactionItem(transaction: filtered[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final categorySpend = ref.watch(analyticsServiceProvider).calculateCategorySpend(transactions);

    final cs = Theme.of(context).colorScheme;

    if (categorySpend.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('분석', style: AppTypography.headlineSm), backgroundColor: cs.surface),
        body: Center(child: Text('통계 데이터가 없습니다.', style: AppTypography.bodyLg)),
      );
    }

    final totalSpend = categorySpend.values.fold(0.0, (sum, val) => sum + val);

    int colorIndex = 0;
    final List<PieChartSectionData> pieChartSections = categorySpend.entries.map((entry) {
      final isTouched = categorySpend.keys.toList().indexOf(entry.key) == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = colorPalette[colorIndex % colorPalette.length];
      colorIndex++;

      final percentage = (entry.value / totalSpend * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.key}\n$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('분석', style: AppTypography.headlineSm),
        backgroundColor: cs.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          children: [
            Text(
              '총 지출: ${totalSpend.toStringAsFixed(0)}원',
              style: AppTypography.headlineMd.copyWith(color: cs.onSurface),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        if (event is FlTapUpEvent && touchedIndex != -1) {
                          final category = categorySpend.keys.elementAt(touchedIndex);
                          _showCategoryTransactions(category);
                        }
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: pieChartSections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
