import 'package:material_ui/material_ui.dart';

class AppColors {
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF211D1D);
  static const darkPrimary = Color(0xFFA32D49);
  static const darkOnPrimary = Color(0xFFFFF1E8);
  static const darkSecondary = Color(0xFFD0A5A0);
  static const darkOnSurface = Color(0xFFF1E6E0);
  static const darkOutline = Color(0xFF554448);

  static const lightBackground = Color(0xFFF3EEE9);
  static const lightSurface = Color(0xFFFFFAF5);
  static const lightPrimary = Color(0xFF8D203B);
  static const lightOnPrimary = Color(0xFFFFF7F0);
  static const lightSecondary = Color(0xFF78545B);
  static const lightOnSurface = Color(0xFF211D1D);
  static const lightOutline = Color(0xFF9B8588);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkBackground,
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkOnSurface,
          outline: AppColors.darkOutline,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        dividerColor: AppColors.darkOutline,
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: AppColors.lightOnPrimary,
          secondary: AppColors.lightSecondary,
          onSecondary: AppColors.lightSurface,
          surface: AppColors.lightSurface,
          onSurface: AppColors.lightOnSurface,
          outline: AppColors.lightOutline,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        dividerColor: AppColors.lightOutline,
      );
}

