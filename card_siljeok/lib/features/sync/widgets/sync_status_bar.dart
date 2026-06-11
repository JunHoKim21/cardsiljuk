import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_provider.dart';

class SyncStatusBar extends ConsumerWidget {
  const SyncStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    final cs = Theme.of(context).colorScheme;

    if (syncState.state == SyncState.idle) {
      return const SizedBox.shrink(); // Hide if idle and never synced
    }

    Color bgColor = cs.primaryContainer;
    Color fgColor = cs.onPrimaryContainer;
    String message = '동기화 중...';
    Widget trailing = const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2));

    if (syncState.state == SyncState.success) {
      bgColor = Colors.green.shade100;
      fgColor = Colors.green.shade800;
      message = '동기화 완료';
      trailing = Icon(Icons.check_circle, size: 16, color: fgColor);
    } else if (syncState.state == SyncState.error) {
      bgColor = cs.errorContainer;
      fgColor = cs.onErrorContainer;
      message = '동기화 실패';
      trailing = TextButton(
        onPressed: () => ref.read(syncProvider.notifier).performSync(),
        style: TextButton.styleFrom(
          foregroundColor: fgColor,
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('재시도'),
      );
    }

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.sync, size: 16, color: fgColor),
              const SizedBox(width: 8),
              Text(
                message,
                style: TextStyle(color: fgColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }
}
