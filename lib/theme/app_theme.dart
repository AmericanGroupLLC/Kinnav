import 'package:flutter/material.dart';

/// Central brand palette for Kinnav.
///
/// These are the kinnav.com values, so the app and the site read as one brand.
/// The site has no token file — the source of truth is what it actually paints
/// (`website/src`), and each colour below notes where it comes from.
///
/// Contrast note: `primary` is a light purple, so white on a solid fill of it
/// clears WCAG AA for large text only. That is how the site uses it too (bold
/// 16px+ on the gradient). Use `primaryDark` behind small white text.
class AppColors {
  AppColors._();

  // Core brand purples. primary is also the site's <meta name="theme-color">.
  static const Color primary = Color(0xFFBF6EEE); // buttons, accents
  static const Color primaryDark = Color(0xFF7B2FB8); // headers, safe-call alert
  static const Color primaryLight = Color(0xFFD4A5F5); // gradient top / highlights

  // Deep end of the site's hero gradient, for dark brand surfaces.
  static const Color heroDeep = Color(0xFF4A1690);
  static const Color heroDarkest = Color(0xFF1E0838);

  // Backgrounds.
  static const Color lavenderBg = Color(0xFFFAF5FF); // app scaffold tint
  static const Color lavenderCard = Color(0xFFEFE0FB); // subtle card fill, borders
  static const Color surface = Colors.white;

  // Text.
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textMuted = Color(0xFF6B7280);

  // Semantic.
  static const Color danger = Color(0xFFE53935); // hang-up / delete
  static const Color online = Color(0xFF43A047); // guardian available
  static const Color pin = Color(0xFF9A4FD8); // map pins

  /// The site's CTA fill: `linear-gradient(135deg, #D4A5F5, #BF6EEE)`.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// The site's hero band, darkest to brand purple.
  static const LinearGradient heroGradient = LinearGradient(
    colors: [heroDarkest, heroDeep, primaryDark],
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
        color: AppColors.lavenderCard,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
