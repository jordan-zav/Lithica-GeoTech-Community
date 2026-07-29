import 'package:flutter/material.dart';

class LithicaColors {
  static const logoNavy = Color(0xFF103050);
  static const logoNavyDeep = Color(0xFF0B2238);
  static const logoGreen = Color(0xFF60A040);
  static const logoLime = Color(0xFF80C030);
  static const logoTeal = Color(0xFF407080);
  static const logoSlate = Color(0xFF607080);
  static const allBlue = Color(0xFF5C86A0);
  static const mineralGreen = Color(0xFF72AC58);
  static const rockCyan = Color(0xFF5E9295);
  static const textureOchre = Color(0xFFA9774D);
  static const textureOchreLight = Color(0xFFD0AA80);
  static const fossilAmber = Color(0xFFB58450);
  static const alterationPurple = Color(0xFF56858A);
  static const alterationPurpleLight = Color(0xFF8FB4B7);
  static const depositCopper = Color(0xFFA46F47);
  static const diagramBlue = Color(0xFF6D8FA8);
  static const glossaryMint = Color(0xFF5D917D);
  static const lightBackground = Color(0xFFF4F6F1);
  static const lightSurface = Colors.white;
  static const darkBackground = Color(0xFF071827);
  static const darkSurface = Color(0xFF102A43);
  static const darkText = Color(0xFFE7ECEF);
}

ThemeData buildLithicaTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme = dark
      ? const ColorScheme.dark(
          primary: LithicaColors.logoGreen,
          onPrimary: LithicaColors.logoNavyDeep,
          secondary: LithicaColors.logoTeal,
          surface: LithicaColors.darkSurface,
          onSurface: LithicaColors.darkText,
          surfaceContainerLow: Color(0xFF123149),
          surfaceContainerHighest: Color(0xFF173A52),
          outline: Color(0x66407080),
        )
      : const ColorScheme.light(
          primary: LithicaColors.logoGreen,
          onPrimary: Colors.white,
          secondary: LithicaColors.logoTeal,
          onSecondary: Colors.white,
          surface: LithicaColors.lightSurface,
          onSurface: LithicaColors.logoNavyDeep,
          surfaceContainerLow: Color(0xFFF8FAF5),
          surfaceContainerHighest: Color(0xFFE8EEE3),
          outline: Color(0x55407080),
        );
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: Colors.transparent,
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.42)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF0B2238) : const Color(0xFFEEF3EA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.48)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: LithicaColors.logoGreen,
          width: 1.4,
        ),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: dark
          ? LithicaColors.logoTeal.withValues(alpha: 0.09)
          : const Color(0xFFF1F3F0),
      selectedColor: LithicaColors.logoGreen.withValues(
        alpha: dark ? 0.16 : 0.12,
      ),
      side: BorderSide(color: scheme.outline.withValues(alpha: 0.42)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    ),
  );
}
