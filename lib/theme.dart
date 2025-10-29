import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameColors {
  static const neonCyan = Color(0xFF00D9FF);
  static const electricPurple = Color(0xFFB026FF);
  static const acidGreen = Color(0xFF39FF14);
  static const deepSpace = Color(0xFF0A0E1A);
  static const darkSteel = Color(0xFF1A1F2E);
  static const slateGray = Color(0xFF2A3142);
  static const pureWhite = Color(0xFFFFFFFF);
  static const lightGray = Color(0xFFB8C5D6);
  static const neonOrange = Color(0xFFFF6B35);
  static const hotPink = Color(0xFFFF006E);
  
  static const healthGreen = acidGreen;
  static const nanoBlue = neonCyan;
  static const damageRed = hotPink;
  static const warningRed = Color(0xFFFF3B3B);
  static const successGreen = acidGreen;
}

class FontSizes {
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 24.0;
  static const double headlineSmall = 22.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: GameColors.neonCyan,
    onPrimary: GameColors.deepSpace,
    primaryContainer: GameColors.slateGray,
    onPrimaryContainer: GameColors.pureWhite,
    secondary: GameColors.electricPurple,
    onSecondary: GameColors.pureWhite,
    tertiary: GameColors.acidGreen,
    onTertiary: GameColors.deepSpace,
    error: GameColors.hotPink,
    onError: GameColors.pureWhite,
    surface: GameColors.darkSteel,
    onSurface: GameColors.pureWhite,
  ),
  brightness: Brightness.light,
  scaffoldBackgroundColor: GameColors.deepSpace,
  appBarTheme: AppBarTheme(
    backgroundColor: GameColors.darkSteel,
    foregroundColor: GameColors.pureWhite,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.orbitron(fontSize: FontSizes.displayLarge, fontWeight: FontWeight.bold, color: GameColors.pureWhite),
    displayMedium: GoogleFonts.orbitron(fontSize: FontSizes.displayMedium, fontWeight: FontWeight.bold, color: GameColors.pureWhite),
    displaySmall: GoogleFonts.orbitron(fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w600, color: GameColors.pureWhite),
    headlineLarge: GoogleFonts.rajdhani(fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600, color: GameColors.pureWhite),
    headlineMedium: GoogleFonts.rajdhani(fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w500, color: GameColors.pureWhite),
    headlineSmall: GoogleFonts.rajdhani(fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.bold, color: GameColors.pureWhite),
    titleLarge: GoogleFonts.rajdhani(fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600, color: GameColors.pureWhite),
    titleMedium: GoogleFonts.rajdhani(fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500, color: GameColors.pureWhite),
    titleSmall: GoogleFonts.rajdhani(fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500, color: GameColors.pureWhite),
    labelLarge: GoogleFonts.inter(fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500, color: GameColors.lightGray),
    labelMedium: GoogleFonts.inter(fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500, color: GameColors.lightGray),
    labelSmall: GoogleFonts.inter(fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w500, color: GameColors.lightGray),
    bodyLarge: GoogleFonts.inter(fontSize: FontSizes.bodyLarge, fontWeight: FontWeight.normal, color: GameColors.pureWhite),
    bodyMedium: GoogleFonts.inter(fontSize: FontSizes.bodyMedium, fontWeight: FontWeight.normal, color: GameColors.lightGray),
    bodySmall: GoogleFonts.inter(fontSize: FontSizes.bodySmall, fontWeight: FontWeight.normal, color: GameColors.lightGray),
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: GameColors.neonCyan,
    onPrimary: GameColors.deepSpace,
    primaryContainer: GameColors.slateGray,
    onPrimaryContainer: GameColors.pureWhite,
    secondary: GameColors.electricPurple,
    onSecondary: GameColors.pureWhite,
    tertiary: GameColors.acidGreen,
    onTertiary: GameColors.deepSpace,
    error: GameColors.hotPink,
    onError: GameColors.pureWhite,
    surface: GameColors.darkSteel,
    onSurface: GameColors.pureWhite,
  ),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: GameColors.deepSpace,
  appBarTheme: AppBarTheme(
    backgroundColor: GameColors.darkSteel,
    foregroundColor: GameColors.pureWhite,
    elevation: 0,
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.orbitron(fontSize: FontSizes.displayLarge, fontWeight: FontWeight.bold, color: GameColors.pureWhite),
    displayMedium: GoogleFonts.orbitron(fontSize: FontSizes.displayMedium, fontWeight: FontWeight.bold, color: GameColors.pureWhite),
    displaySmall: GoogleFonts.orbitron(fontSize: FontSizes.displaySmall, fontWeight: FontWeight.w600, color: GameColors.pureWhite),
    headlineLarge: GoogleFonts.rajdhani(fontSize: FontSizes.headlineLarge, fontWeight: FontWeight.w600, color: GameColors.pureWhite),
    headlineMedium: GoogleFonts.rajdhani(fontSize: FontSizes.headlineMedium, fontWeight: FontWeight.w500, color: GameColors.pureWhite),
    headlineSmall: GoogleFonts.rajdhani(fontSize: FontSizes.headlineSmall, fontWeight: FontWeight.bold, color: GameColors.pureWhite),
    titleLarge: GoogleFonts.rajdhani(fontSize: FontSizes.titleLarge, fontWeight: FontWeight.w600, color: GameColors.pureWhite),
    titleMedium: GoogleFonts.rajdhani(fontSize: FontSizes.titleMedium, fontWeight: FontWeight.w500, color: GameColors.pureWhite),
    titleSmall: GoogleFonts.rajdhani(fontSize: FontSizes.titleSmall, fontWeight: FontWeight.w500, color: GameColors.pureWhite),
    labelLarge: GoogleFonts.inter(fontSize: FontSizes.labelLarge, fontWeight: FontWeight.w500, color: GameColors.lightGray),
    labelMedium: GoogleFonts.inter(fontSize: FontSizes.labelMedium, fontWeight: FontWeight.w500, color: GameColors.lightGray),
    labelSmall: GoogleFonts.inter(fontSize: FontSizes.labelSmall, fontWeight: FontWeight.w500, color: GameColors.lightGray),
    bodyLarge: GoogleFonts.inter(fontSize: FontSizes.bodyLarge, fontWeight: FontWeight.normal, color: GameColors.pureWhite),
    bodyMedium: GoogleFonts.inter(fontSize: FontSizes.bodyMedium, fontWeight: FontWeight.normal, color: GameColors.lightGray),
    bodySmall: GoogleFonts.inter(fontSize: FontSizes.bodySmall, fontWeight: FontWeight.normal, color: GameColors.lightGray),
  ),
);
