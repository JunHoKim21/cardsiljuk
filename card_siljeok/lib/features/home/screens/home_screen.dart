import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../util/sms_parser.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.primaryContainer,
            child: const Icon(Icons.person, color: AppColors.onPrimary),
          ),
        ),
        title: const Text('카드실적'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.stackGapSm),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainSummaryCard(context),
            const SizedBox(height: AppSpacing.stackGapLg),
            _buildCardListSection(context),
            const SizedBox(height: AppSpacing.stackGapLg),
            ElevatedButton(
              onPressed: () async {
                await SmsParser().init();
              },
              child: const Text('SMS 파싱 시작'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainSummaryCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: isDark ? 0.0 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: isDark ? Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        children: [
          // Ring Chart (임시 구현)
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 12,
                  backgroundColor: cs.surfaceContainerHighest,
                  color: cs.primary,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('달성률', style: AppTypography.labelSm.copyWith(color: cs.onSurface)),
                  Text('72%', style: AppTypography.headlineMd.copyWith(color: cs.primary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackGapLg),
          Divider(color: cs.outlineVariant, height: 1),
          const SizedBox(height: AppSpacing.stackGapMd),
          
          // Data Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('총결제액', style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text('850,000원', style: AppTypography.headlineMd.copyWith(color: cs.onSurface)),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: cs.outlineVariant),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('인정 실적', style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Text('620,000원', style: AppTypography.headlineMd.copyWith(color: cs.secondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackGapMd),
          
          // Excluded Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Row(
              children: [
                Text('실적 제외 항목', style: AppTypography.labelLg.copyWith(color: cs.onSurface)),
                const Spacer(),
                Text('230,000원', style: AppTypography.labelLg.copyWith(color: cs.error)),
                const SizedBox(width: 8),
                Icon(Icons.info_outline, size: 16, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardListSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('보유 카드 실적', style: AppTypography.headlineSm.copyWith(color: cs.onSurface)),
            TextButton(
              onPressed: () {},
              child: Text('상세보기', style: AppTypography.labelLg.copyWith(color: cs.primary)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.stackGapSm),
        _buildCardItem(
          context: context,
          cardName: '현대카드 Zero',
          description: '다음 구간까지 80,000원 남음',
          isMet: false,
          currentAmt: '420,000',
          targetAmt: '500,000',
          progress: 0.84,
          indicatorColor: Colors.blueAccent,
        ),
        const SizedBox(height: AppSpacing.stackGapMd),
        _buildCardItem(
          context: context,
          cardName: '신한카드 Mr.Life',
          description: '이번 달 실적 달성 완료!',
          isMet: true,
          currentAmt: '350,000',
          targetAmt: '300,000',
          progress: 1.0,
          indicatorColor: Colors.deepPurpleAccent,
        ),
      ],
    );
  }

  Widget _buildCardItem({
    required BuildContext context,
    required String cardName,
    required String description,
    required bool isMet,
    required String currentAmt,
    required String targetAmt,
    required double progress,
    required Color indicatorColor,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: isDark ? 0.0 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4), width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vertical Indicator Bar
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLg),
                  bottomLeft: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cardName, style: AppTypography.labelLg.copyWith(color: cs.onSurface)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isMet ? cs.secondaryContainer : cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text(
                            isMet ? '충족' : '미달',
                            style: AppTypography.labelSm.copyWith(
                              color: isMet ? cs.onSecondaryContainer : cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(description, style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Text('$currentAmt / ${targetAmt}원', style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: cs.surfaceContainerHighest,
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                      minHeight: 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
