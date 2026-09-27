import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Brand Colours ────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Backgrounds / surfaces
  static const Color surface         = Color(0xFF00170E);
  static const Color surfaceDim      = Color(0xFF00170E);
  static const Color surfaceLowest   = Color(0xFF00120A);
  static const Color surfaceLow      = Color(0xFF052016);
  static const Color surfaceContainer= Color(0xFF09241A);
  static const Color surfaceHigh     = Color(0xFF152F24);
  static const Color surfaceHighest  = Color(0xFF203A2F);
  static const Color surfaceBright   = Color(0xFF243E33);
  static const Color surfaceVariant  = Color(0xFF203A2F);

  // Brand primaries
  static const Color primary         = Color(0xFF4EDEA3);
  static const Color primaryContainer= Color(0xFF10B981);
  static const Color primaryFixed    = Color(0xFF6FFBBE);
  static const Color primaryFixedDim = Color(0xFF4EDEA3);
  static const Color onPrimary       = Color(0xFF003824);
  static const Color onPrimaryContainer = Color(0xFF00422B);
  static const Color inversePrimary  = Color(0xFF006C49);

  // Secondary (gold)
  static const Color secondary       = Color(0xFFFFB95F);
  static const Color secondaryFixed  = Color(0xFFFFDDB8);
  static const Color secondaryFixedDim=Color(0xFFFFB95F);
  static const Color secondaryContainer=Color(0xFFEE9800);
  static const Color onSecondary     = Color(0xFF472A00);
  static const Color onSecondaryContainer = Color(0xFF5B3800);

  // Tertiary
  static const Color tertiary        = Color(0xFF68DBA9);
  static const Color tertiaryContainer=Color(0xFF3EB686);
  static const Color tertiaryFixed   = Color(0xFF85F8C4);
  static const Color tertiaryFixedDim= Color(0xFF68DBA9);
  static const Color onTertiary      = Color(0xFF003825);
  static const Color onTertiaryContainer = Color(0xFF00422C);

  // Text / on-surface
  static const Color onSurface       = Color(0xFFCBE9D9);
  static const Color onSurfaceVariant= Color(0xFFBBCABF);
  static const Color onBackground    = Color(0xFFCBE9D9);
  static const Color outline         = Color(0xFF86948A);
  static const Color outlineVariant  = Color(0xFF3C4A42);

  // Error
  static const Color error           = Color(0xFFFFB4AB);
  static const Color errorContainer  = Color(0xFF93000A);
  static const Color onError         = Color(0xFF690005);
  static const Color onErrorContainer= Color(0xFFFFDAD6);

  // Misc
  static const Color inverseOnSurface= Color(0xFF1B352A);
  static const Color inverseSurface  = Color(0xFFCBE9D9);

  // Gold shades (for borders / accents)
  static const Color goldBorder      = Color(0x52FBBF24);
  static const Color goldAccent      = Color(0xFFFBBF24);
  static const Color goldLight       = Color(0xFFFDE68A);
}

// ─── App Theme ────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.surface,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.dark,
        primary:   AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary:  AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error:     AppColors.error,
        onError:   AppColors.onError,
        surface:   AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerHighest: AppColors.surfaceHighest,
        outline:   AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor:    AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: AppColors.onSurface.withOpacity(0.35)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceLowest),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

// ─── Text Styles ──────────────────────────────────────────────────────────────
class AppText {
  AppText._();

  static TextStyle get displayLg => GoogleFonts.plusJakartaSans(
    fontSize: 40, fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 40, color: AppColors.onSurface);

  static TextStyle get displayMobile => GoogleFonts.plusJakartaSans(
    fontSize: 32, fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 32, color: AppColors.onSurface);

  static TextStyle get headlineLg => GoogleFonts.plusJakartaSans(
    fontSize: 28, fontWeight: FontWeight.w600,
    letterSpacing: -0.015 * 28, color: AppColors.onSurface);

  static TextStyle get headlineMd => GoogleFonts.plusJakartaSans(
    fontSize: 24, fontWeight: FontWeight.w600,
    letterSpacing: -0.01 * 24, color: AppColors.onSurface);

  static TextStyle get headlineSm => GoogleFonts.plusJakartaSans(
    fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurface);

  static TextStyle get titleMd => GoogleFonts.plusJakartaSans(
    fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.onSurface);

  static TextStyle get labelLg => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w600,
    letterSpacing: 0.02 * 14, color: AppColors.onSurface);

  static TextStyle get labelMd => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w600,
    letterSpacing: 0.04 * 12, color: AppColors.onSurface);

  static TextStyle get labelSm => GoogleFonts.plusJakartaSans(
    fontSize: 10, fontWeight: FontWeight.w700,
    letterSpacing: 0.06 * 10, color: AppColors.onSurface);

  static TextStyle get bodyLg => GoogleFonts.plusJakartaSans(
    fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onSurface);

  static TextStyle get bodyMd => GoogleFonts.plusJakartaSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.onSurface);

  static TextStyle get bodySm => GoogleFonts.plusJakartaSans(
    fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.onSurface);
}
