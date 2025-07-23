import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  // Глобальный стиль для AppBar
  static AppBarTheme get appBarTheme => const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.white, size: 24),
    titleTextStyle: TextStyle(
      color: AppColors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );

  // Глобальный стиль для SnackBar
  static SnackBarThemeData get snackBarTheme => const SnackBarThemeData(
    backgroundColor: AppColors.primary,
    contentTextStyle: TextStyle(color: AppColors.white, fontSize: 16),
  );

  // Глобальный стиль для кнопок
  static ElevatedButtonThemeData get elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      );

  // Глобальный стиль для текстовых кнопок
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

// Глобальная тема приложения
class FantasyTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: 'Forum',
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surface,
      background: AppColors.background,
      onPrimary: AppColors.white,
      onSurface: AppColors.white,
      onBackground: AppColors.white,
    ),
    appBarTheme: AppThemes.appBarTheme,
    scaffoldBackgroundColor: AppColors.background,
    snackBarTheme: AppThemes.snackBarTheme,
    elevatedButtonTheme: AppThemes.elevatedButtonTheme,
    textButtonTheme: AppThemes.textButtonTheme,
  );
}
