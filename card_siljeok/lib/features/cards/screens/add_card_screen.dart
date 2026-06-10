import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/model/card_model.dart';
import 'package:card_siljeok/features/cards/providers/card_provider.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends ConsumerState<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveCard() async {
    if (!_formKey.currentState!.validate()) return;
    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    final category = _categoryController.text.trim();
    final newCard = CardModel(
      id: const Uuid().v4(),
      cardName: name,
      amount: amount,
      date: DateTime.now(),
      category: category,
    );
    await ref.read(cardProvider.notifier).addCard(newCard);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('카드 추가', style: AppTypography.headlineLg.copyWith(color: cs.onSurface)),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '카드 이름'),
                validator: (v) => (v == null || v.isEmpty) ? '입력 필요' : null,
              ),
              const SizedBox(height: AppSpacing.stackGapMd),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: '한도 금액'),
                keyboardType: TextInputType.number,
                validator: (v) => (v == null || double.tryParse(v) == null) ? '숫자를 입력하세요' : null,
              ),
              const SizedBox(height: AppSpacing.stackGapMd),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: '카테고리'),
                validator: (v) => (v == null || v.isEmpty) ? '입력 필요' : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveCard,
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
