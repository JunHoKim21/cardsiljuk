import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:card_siljeok/services/firestore_service.dart';

class KeywordRuleEngine extends StateNotifier<List<String>> {
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription<List<String>>? _subscription;

  KeywordRuleEngine() : super([]) {
    _init();
  }

  void _init() {
    _subscription = _firestoreService.streamKeywords().listen((keywords) {
      state = keywords;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> addKeyword(String keyword) async {
    if (!state.contains(keyword)) {
      await _firestoreService.saveKeyword(keyword);
    }
  }

  Future<void> removeKeyword(String keyword) async {
    await _firestoreService.deleteKeyword(keyword);
  }

  /// 복합 룰 검사 (임시로 텍스트 포함 및 정규식 매칭 등 지원 가능)
  /// 지금은 단순 포함 여부와 카테고리 일치 여부 등을 확장하기 좋게 구성
  bool check(String description, {String? category}) {
    if (description.isEmpty && (category == null || category.isEmpty)) return false;
    
    // 단순 키워드 매칭
    for (final keyword in state) {
      if (description.contains(keyword)) {
        return true;
      }
      // 만약 정규식 형태(예: ^카카오.*)로 들어온다면 여기서 RegExp 객체로 검증하는 로직 추가 가능
      // if (keyword.startsWith('^')) {
      //   final regExp = RegExp(keyword);
      //   if (regExp.hasMatch(description)) return true;
      // }
    }
    return false;
  }
}

final keywordRuleEngineProvider = StateNotifierProvider<KeywordRuleEngine, List<String>>((ref) {
  return KeywordRuleEngine();
});
