import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceVariant = Color(0xFF1C2535);
  static const Color cardBorder = Color(0xFF1E2D40);

  static const Color accent = Color(0xFF00D4FF);
  static const Color accentDim = Color(0xFF0066FF);

  static const Color gainGreen = Color(0xFF00E676);
  static const Color gainGreenDim = Color(0xFF1A3D2B);
  static const Color lossRed = Color(0xFFFF3D57);
  static const Color lossRedDim = Color(0xFF3D1520);
  static const Color neutral = Color(0xFF8899AA);

  static const Color textPrimary = Color(0xFFEAEEF5);
  static const Color textSecondary = Color(0xFF6B7A8D);
  static const Color textMuted = Color(0xFF3D4D5E);

  static const Color dragHandle = Color(0xFF2D3F55);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        background: AppColors.background,
        surface: AppColors.surface,
        primary: AppColors.accent,
        secondary: AppColors.accentDim,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme().apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary),
      dividerColor: AppColors.cardBorder,
    );
  }
}
