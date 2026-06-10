import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        secondary: AppColors.secondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        error: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.onSurface),
        titleTextStyle: AppTypography.headlineSm,
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTypography.headlineLg,
        headlineMedium: AppTypography.headlineMd,
        headlineSmall: AppTypography.headlineSm,
        bodyLarge: AppTypography.bodyLg,
        bodyMedium: AppTypography.bodyMd,
        labelLarge: AppTypography.labelLg,
        labelSmall: AppTypography.labelSm,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTypography.labelLg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.containerPadding, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF111318),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF9ECAFF),        // 밝은 파랑 (라이트모드 대비)
        onPrimary: Color(0xFF003063),
        primaryContainer: Color(0xFF00448B),
        secondary: Color(0xFF72DDB9),      // 밝은 민트
        onSecondary: Color(0xFF003827),
        secondaryContainer: Color(0xFF005140),
        onSecondaryContainer: Color(0xFF8EFAD4),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        surface: Color(0xFF1E2128),        // 카드 배경
        onSurface: Color(0xFFE3E2E6),      // 기본 텍스트 (거의 흰색)
        onSurfaceVariant: Color(0xFFC4C6D0), // 보조 텍스트
        surfaceContainerLow: Color(0xFF252830),  // 약간 밝은 배경 (인포카드)
        surfaceContainerHighest: Color(0xFF2E3038), // 진행바 배경
        outlineVariant: Color(0xFF44474F),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFE3E2E6)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1C23),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFE3E2E6)),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE3E2E6),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Color(0xFFE3E2E6), fontSize: 22, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: Color(0xFFE3E2E6), fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(color: Color(0xFFE3E2E6), fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFFC4C6D0), fontSize: 16),
        bodyMedium: TextStyle(color: Color(0xFFC4C6D0), fontSize: 14),
        labelLarge: TextStyle(color: Color(0xFFE3E2E6), fontSize: 14, fontWeight: FontWeight.w600),
        labelSmall: TextStyle(color: Color(0xFFC4C6D0), fontSize: 12),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1A1C23),
        indicatorColor: const Color(0xFF005140),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Color(0xFF72DDB9), fontSize: 12, fontWeight: FontWeight.w600);
          }
          return const TextStyle(color: Color(0xFFC4C6D0), fontSize: 12);
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF72DDB9));
          }
          return const IconThemeData(color: Color(0xFFC4C6D0));
        }),
      ),
    );
  }
}
