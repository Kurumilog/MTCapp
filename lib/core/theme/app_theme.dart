/// 1) Общее назначение:
///    Глобальная конфигурация темы Material 3 для приложения "MTC Cloud".
/// 2) С какими файлами связан:
///    - lib/core/theme/app_colors.dart (цветовые константы)
/// 3) Описание функций:
///    - get theme: возвращает ThemeData (Material 3) с фирменной палитрой MTC и шрифтом Nunito.
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme => lightTheme;

  static ThemeData get lightTheme {
    return _buildTheme(Brightness.light);
  }

  static ThemeData get darkTheme {
    return _buildTheme(Brightness.dark);
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scaffoldColor = isDark ? const Color(0xFF111216) : Colors.white;
    final surfaceVariant = isDark ? const Color(0xFF1E2128) : AppColors.surfaceVariant;
    final onSurfaceColor = isDark ? const Color(0xFFE6E1E5) : AppColors.onSurface;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryRed,
      primary: AppColors.primaryRed,
      onPrimary: Colors.white,
      secondary: AppColors.primaryRed,
      onSecondary: Colors.white,
      surface: scaffoldColor,
      onSurface: onSurfaceColor,
      surfaceContainerHighest: surfaceVariant,
      error: AppColors.primaryRed,
      brightness: brightness,
    );

    final textTheme = GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      displayMedium: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      displaySmall: GoogleFonts.nunito(fontWeight: FontWeight.bold),
      headlineLarge: GoogleFonts.nunito(fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.nunito(fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.nunito(fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.nunito(),
      bodyMedium: GoogleFonts.nunito(),
      bodySmall: GoogleFonts.nunito(),
      labelLarge: GoogleFonts.nunito(fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.nunito(),
      labelSmall: GoogleFonts.nunito(),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: scaffoldColor,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurfaceColor,
        ),
        iconTheme: IconThemeData(color: onSurfaceColor),
      ),

      // FilledButton (AuthButton использует его)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          elevation: 0,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          minimumSize: const Size(double.infinity, 56),
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.primaryRed),
          textStyle: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryRed,
          textStyle: GoogleFonts.nunito(fontWeight: FontWeight.w600),
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? const Color(0xFF2A2D34) : Colors.grey.shade200,
          ),
        ),
        margin: EdgeInsets.zero,
      ),

      // InputDecoration (TextField)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9BA0AA) : Colors.grey.shade500,
          fontSize: 16,
        ),
        prefixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? AppColors.primaryRed
              : (isDark ? const Color(0xFF9BA0AA) : Colors.grey.shade500),
        ),
      ),

      // NavigationBar (M3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: AppColors.primaryRed.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryRed);
          }
          return IconThemeData(
            color: isDark ? const Color(0xFF9BA0AA) : Colors.grey.shade500,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryRed,
            );
          }
          return GoogleFonts.nunito(
            fontSize: 12,
            color: isDark ? const Color(0xFF9BA0AA) : Colors.grey.shade500,
          );
        }),
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF2A2D34) : Colors.grey.shade200,
        thickness: 0.5,
        space: 0,
      ),

      // ListTile
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
