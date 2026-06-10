import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // 상태 토글을 임시로 보여주기 위한 변수 (향후 Riverpod 적용 대상)
  bool _isCoffeeExcluded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결제 내역 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: AppSpacing.stackGapSm),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.containerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildMonthFilterHeader(),
                  const SizedBox(height: AppSpacing.stackGapLg),
                  _buildTopSummaryCard(),
                  const SizedBox(height: AppSpacing.stackGapLg),
                ],
              ),
            ),
          ),
          
          // Transaction List (날짜별 그룹화 예시)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
              child: Text('October 24, Tuesday', style: AppTypography.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTransactionItem(
                  icon: Icons.local_cafe,
                  merchantName: '스타벅스 서울역점',
                  timeAndCategory: '14:20 · 카페',
                  amount: '12,500원',
                  isExcluded: _isCoffeeExcluded,
                  onToggle: () {
                    setState(() {
                      _isCoffeeExcluded = !_isCoffeeExcluded;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.stackGapMd),
                _buildTransactionItem(
                  icon: Icons.shopping_bag,
                  merchantName: '무신사스탠다드',
                  timeAndCategory: '11:05 · 쇼핑',
                  amount: '58,000원',
                  isExcluded: false,
                  onToggle: () {},
                ),
              ]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
              child: Text('October 23, Monday', style: AppTypography.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.containerPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildTransactionItem(
                  icon: Icons.home,
                  merchantName: '아파트 관리비',
                  timeAndCategory: '09:00 · 주거',
                  amount: '230,000원',
                  isExcluded: true, // 자동 제외 예시
                  onToggle: () {},
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildMonthFilterHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(icon: const Icon(Icons.chevron_left), onPressed: () {}),
            const Text('2023년 10월', style: AppTypography.headlineSm),
            IconButton(icon: const Icon(Icons.chevron_right), onPressed: () {}),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.outlineVariant),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: IconButton(
            icon: const Icon(Icons.filter_list),
            iconSize: 20,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            padding: EdgeInsets.zero,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTopSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.containerPadding),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Target Performance', style: AppTypography.labelLg.copyWith(color: AppColors.onPrimary.withValues(alpha: 0.8))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: const Text('Target Met', style: AppTypography.labelSm),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.stackGapSm),
          const Text('1,240,000 KRW', style: TextStyle(
            fontFamily: AppTypography.fontFamilyEn,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.onPrimary,
          )),
          const SizedBox(height: AppSpacing.stackGapLg),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.85,
                  backgroundColor: AppColors.onPrimary.withValues(alpha: 0.2),
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  minHeight: 6,
                ),
              ),
              const SizedBox(width: 12),
              Text('85% of monthly goal', style: AppTypography.labelSm.copyWith(color: AppColors.onPrimary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String merchantName,
    required String timeAndCategory,
    required String amount,
    required bool isExcluded,
    required VoidCallback onToggle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          // 카테고리 아이콘
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(width: AppSpacing.stackGapMd),
          
          // 가맹점 및 카테고리
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(merchantName, style: AppTypography.labelLg, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(timeAndCategory, style: AppTypography.bodyMd),
              ],
            ),
          ),
          
          // 우측 금액 및 상태
          GestureDetector(
            onTap: onToggle,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamilyKo,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isExcluded ? AppColors.outlineVariant : AppColors.onSurface,
                    decoration: isExcluded ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isExcluded ? AppColors.surfaceContainer : AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    isExcluded ? '제외' : '인정',
                    style: AppTypography.labelSm.copyWith(
                      color: isExcluded ? AppColors.onSurfaceVariant : AppColors.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
