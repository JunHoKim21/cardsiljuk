import 'package:flutter/material.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/core/theme/app_colors.dart';

class TransactionFilterWidget extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final String? initialCategory;
  final double? initialMinAmount;
  final double? initialMaxAmount;

  const TransactionFilterWidget({
    super.key,
    this.initialDateRange,
    this.initialCategory,
    this.initialMinAmount,
    this.initialMaxAmount,
  });

  @override
  State<TransactionFilterWidget> createState() => _TransactionFilterWidgetState();
}

class _TransactionFilterWidgetState extends State<TransactionFilterWidget> {
  DateTimeRange? _dateRange;
  String? _category;
  double _minAmount = 0;
  double _maxAmount = 1000000; // arbitrary max

  @override
  void initState() {
    super.initState();
    _dateRange = widget.initialDateRange;
    _category = widget.initialCategory;
    _minAmount = widget.initialMinAmount ?? 0;
    _maxAmount = widget.initialMaxAmount ?? 1000000;
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final lastYear = DateTime(now.year - 1);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: lastYear,
      lastDate: now,
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _apply() {
    Navigator.of(context).pop(
      TransactionFilterResult(
        dateRange: _dateRange,
        category: _category,
        minAmount: _minAmount,
        maxAmount: _maxAmount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.containerPadding,
        right: AppSpacing.containerPadding,
        top: AppSpacing.containerPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('거래 필터', style: AppTypography.headlineMd.copyWith(color: cs.onSurface)),
          const SizedBox(height: 16),
          // Date range picker
          ListTile(
            title: Text('기간', style: AppTypography.bodyLg.copyWith(color: cs.onSurface)),
            subtitle: Text(_dateRange == null
                ? '전체 기간'
                : '${_dateRange!.start.toLocal().toString().split(' ')[0]} ~ ${_dateRange!.end.toLocal().toString().split(' ')[0]}',
                style: AppTypography.bodySm.copyWith(color: cs.onSurfaceVariant)),
            trailing: Icon(Icons.calendar_today, color: cs.onSurfaceVariant),
            onTap: _pickDateRange,
          ),
          const SizedBox(height: 12),
          // Category input (simple text field for demo)
          TextField(
            decoration: InputDecoration(
              labelText: '카테고리',
              labelStyle: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.roundedSm)),
            ),
            onChanged: (v) => _category = v.isEmpty ? null : v,
            controller: TextEditingController(text: _category ?? ''),
          ),
          const SizedBox(height: 12),
          // Amount range sliders
          Text('금액 범위', style: AppTypography.bodyLg.copyWith(color: cs.onSurface)),
          RangeSlider(
            min: 0,
            max: 1000000,
            divisions: 100,
            values: RangeValues(_minAmount, _maxAmount),
            onChanged: (RangeValues values) {
              setState(() {
                _minAmount = values.start;
                _maxAmount = values.end;
              });
            },
            activeColor: AppColors.primary,
            inactiveColor: cs.surfaceContainerHighest,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\${_minAmount.toInt()}원', style: AppTypography.bodySm.copyWith(color: cs.onSurfaceVariant)),
              Text('\${_maxAmount.toInt()}원', style: AppTypography.bodySm.copyWith(color: cs.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.roundedSm)),
              ),
              onPressed: _apply,
              child: Text('적용', style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
            ),
          ),
        ],
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
