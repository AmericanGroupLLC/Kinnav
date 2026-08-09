import 'package:flutter/material.dart';

/// Central brand palette for Kinnav, derived from the product's purple / lavender
/// identity in the design deck and reference screens.
class AppColors {
  AppColors._();

  // Core brand purples.
  static const Color primary = Color(0xFF9B59D0); // buttons, accents
  static const Color primaryDark = Color(0xFF6A1B9A); // headers, safe-call alert
  static const Color primaryLight = Color(0xFFB57BE0); // gradient top / highlights

  // Backgrounds.
  static const Color lavenderBg = Color(0xFFF4ECFA); // app scaffold tint
  static const Color lavenderCard = Color(0xFFEDE3F6); // subtle card fill
  static const Color surface = Colors.white;

  // Text.
  static const Color textDark = Color(0xFF3A3A3A);
  static const Color textMuted = Color(0xFF8A8A8A);

  // Semantic.
  static const Color danger = Color(0xFFE53935); // hang-up / delete
  static const Color online = Color(0xFF34C759); // guardian available
  static const Color pin = Color(0xFF9C27B0); // map pins

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.lavenderBg,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.textDark,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 26,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textDark,
        displayColor: AppColors.textDark,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE4DAEF),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
