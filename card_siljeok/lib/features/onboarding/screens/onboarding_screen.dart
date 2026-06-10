import 'package:flutter/material.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../main/screens/main_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // 닫기 액션 (임시)
            },
            child: const Text('닫기', style: AppTypography.labelLg),
          ),
          const SizedBox(width: AppSpacing.stackGapSm),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              
              // 모바일 폰 모양 일러스트레이션 (임시 아이콘)
              Icon(
                Icons.mark_email_unread_outlined,
                size: 80,
                color: cs.primary,
              ),
              const SizedBox(height: AppSpacing.stackGapLg),
              
              // Header
              Text(
                '복잡한 인증 없이\n바로 시작하세요',
                style: AppTypography.headlineLg.copyWith(color: cs.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.stackGapMd),
              
              // Sub Header
              Text(
                '카드사 연동, 공인인증서 필요 없습니다.\n결제 알림 권한만 허용하면 끝!',
                style: AppTypography.bodyLg.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Info Cards
              _buildInfoCard(
                context: context,
                icon: Icons.chat_outlined,
                title: '문자/알림 분석',
                description: '실시간 결제 내역을 자동으로 수집합니다.',
              ),
              const SizedBox(height: AppSpacing.stackGapMd),
              _buildInfoCard(
                context: context,
                icon: Icons.security_outlined,
                title: '안전한 데이터 관리',
                description: '수집된 정보는 단말기 내에만 안전하게 보관됩니다.',
              ),
              
              const Spacer(),
              
              // Bottom CTA
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                child: const Text('알림 권한 허용하고 시작하기 >'),
              ),
              const SizedBox(height: AppSpacing.stackGapMd),
              
              // 하단 캡션
              Text(
                '시작하기를 누르면 이용약관 및 개인정보처리방침에 동의하게 됩니다.',
                style: AppTypography.labelSm.copyWith(color: cs.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.stackGapLg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required BuildContext context, required IconData icon, required String title, required String description}) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      ),
      child: Row(
        children: [
          Icon(icon, color: cs.primary, size: 28),
          const SizedBox(width: AppSpacing.stackGapMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.labelLg.copyWith(color: cs.onSurface)),
                const SizedBox(height: 4),
                Text(description, style: AppTypography.bodyMd.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
