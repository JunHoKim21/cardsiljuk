import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../sync/providers/sync_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final syncState = ref.watch(syncProvider);
    final isSyncing = syncState.state == SyncState.syncing;

    return Scaffold(
      appBar: AppBar(
        title: const Text('카드 실적 메이트'),
        actions: [
          IconButton(
            icon: isSyncing 
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.sync),
            onPressed: isSyncing ? null : () {
              ref.read(syncProvider.notifier).performSync();
            },
            tooltip: '마이데이터 동기화',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.credit_card, size: 80, color: cs.primary),
            const SizedBox(height: 16),
            const Text(
              '환영합니다!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('우측 상단의 동기화 버튼을 눌러 결제 내역을 불러오세요.'),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('마이데이터 동기화 실행'),
              onPressed: isSyncing ? null : () {
                ref.read(syncProvider.notifier).performSync();
              },
            ),
          ],
        ),
      ),
    );
  }
}
