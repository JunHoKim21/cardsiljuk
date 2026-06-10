import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';
import 'package:card_siljeok/core/theme/app_colors.dart';
import 'package:card_siljeok/core/theme/app_spacing.dart';
import '../keyword_rule_engine.dart';

class KeywordManagementScreen extends ConsumerStatefulWidget {
  const KeywordManagementScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<KeywordManagementScreen> createState() => _KeywordManagementScreenState();
}

class _KeywordManagementScreenState extends ConsumerState<KeywordManagementScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addKeyword() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await ref.read(keywordRuleEngineProvider.notifier).addKeyword(text);
      _controller.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('키워드 "$text" 추가됨')),
        );
      }
    }
  }

  void _removeKeyword(String keyword) async {
    await ref.read(keywordRuleEngineProvider.notifier).removeKeyword(keyword);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('키워드 "$keyword" 삭제됨')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keywords = ref.watch(keywordRuleEngineProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('제외 키워드 관리', style: AppTypography.headlineSm),
        backgroundColor: cs.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('실적 통계에서 제외할 키워드를 등록하세요.', style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '키워드 입력 (예: 송금, 더치페이)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _addKeyword(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addKeyword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.roundedSm),
                    ),
                  ),
                  child: const Text('추가'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('등록된 키워드 (${keywords.length})', style: AppTypography.headlineSm),
            const SizedBox(height: 8),
            Expanded(
              child: keywords.isEmpty
                  ? Center(child: Text('등록된 키워드가 없습니다.', style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)))
                  : ListView.builder(
                      itemCount: keywords.length,
                      itemBuilder: (context, index) {
                        final keyword = keywords[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(keyword, style: AppTypography.bodyLg),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.error),
                              onPressed: () => _removeKeyword(keyword),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
