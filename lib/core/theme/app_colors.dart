/// 1) Общее назначение:
///    Цветовые константы палитры MTC Cloud, согласованные с Material 3 ColorScheme.
/// 2) С какими файлами связан:
///    - Используется в app_theme.dart и точечно в UI-компонентах.
/// 3) Описание:
///    Только те константы, которых нет в ColorScheme (accent, surface-варианты).
library;
import 'package:flutter/material.dart';

class AppColors {
  // Основной бренд MTC
  static const Color primaryRed = Color(0xFFE31B2D);

  // Текст / иконки на светлом фоне
  static const Color onSurface = Color(0xFF1C1B1F);

  // Заливка полей ввода (M3 surfaceVariant)
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Полупрозрачный белый (используется в auth-карточках)
  static const Color translucentWhite = Color(0xB3FFFFFF);
}
