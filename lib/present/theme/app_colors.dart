import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета фэнтезийной темы
  static const Color primary = Color(0xFF5B2333);
  static const Color background = Color(0xFF1A1A1A);
  static const Color surface = Color(0xFF2A2A2A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Акцентные цвета
  static const Color accent = Color(0xFF5B2333);
  static const Color accentLight = Color(0xFF7A2F42);
  static const Color accentDark = Color(0xFF3D1A22);

  // Цвета для статусов
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Градиенты
  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
  );

  // Тени
  static const Color shadowColor = Color(0xFF5B2333);
  static const Color shadowColorLight = Color(0x1A5B2333);

  // Устаревшие цвета (для совместимости)
  static const Color blue = Color(0xFF163955);
  static const Color bg = Color(0xFFFEF9F0);
  static const Color border = Color(0xFFE0E3E7);
}
