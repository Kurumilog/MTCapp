/**
 * 1) Общее назначение:
 *    Содержит глобальную конфигурацию темы всего приложения (шрифты, базовые стили текста).
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (использует цвета для темы)
 * 3) Описание функций:
 *    - get theme: возвращает готовый объект ThemeData для использования в материальном приложении.
 */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryRed,
      scaffoldBackgroundColor: AppColors.white,
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          color: AppColors.primaryRed,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: AppColors.textRed,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: AppColors.textRed,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        primary: AppColors.primaryRed,
      ),
    );
  }
}
