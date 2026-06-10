import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _keywordsBoxName = 'keywords';

class KeywordRuleEngine extends StateNotifier<List<String>> {
  KeywordRuleEngine() : super([]) {
    _loadKeywords();
  }

  Future<void> _loadKeywords() async {
    final box = await Hive.openBox<String>(_keywordsBoxName);
    state = box.values.toList();
    box.watch().listen((event) {
      state = box.values.toList();
    });
  }

  Future<void> addKeyword(String keyword) async {
    final box = Hive.box<String>(_keywordsBoxName);
    if (!box.values.contains(keyword)) {
      await box.add(keyword);
    }
  }

  Future<void> removeKeyword(String keyword) async {
    final box = Hive.box<String>(_keywordsBoxName);
    final keyToRemove = box.keys.firstWhere(
      (k) => box.get(k) == keyword,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      await box.delete(keyToRemove);
    }
  }

  bool check(String description) {
    if (description.isEmpty) return false;
    for (final keyword in state) {
      if (description.contains(keyword)) {
        return true;
      }
    }
    return false;
  }
}

final keywordRuleEngineProvider = StateNotifierProvider<KeywordRuleEngine, List<String>>((ref) {
  return KeywordRuleEngine();
});
