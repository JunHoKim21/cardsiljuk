import 'package:flutter/material.dart';
import 'package:card_siljeok/core/theme/app_typography.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('설정', style: AppTypography.headlineLg.copyWith(color: cs.onSurface)),
        backgroundColor: cs.surface,
        elevation: 0,
      ),
      body: Center(
        child: Text('설정 화면', style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant)),
      ),
    );
  }
}
