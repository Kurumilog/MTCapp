/**
 * 1) Общее назначение:
 *    Хранит все цветовые константы, используемые в дизайне приложения (палитра MTC Cloud).
 * 2) С какими файлами связан:
 *    - Используется практически во всех UI компонентах (кнопки, поля, фоны).
 * 3) Описание функций:
 *    - Не содержит методов. Предоставляет статические константы цветов для единообразия дизайна.
 */
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryRed = Color(0xFFE31B2D); // A slightly softer red similar to the image
  static const Color brightRed = Color(0xFFFF0000);
  
  static const Color textRed = Color(0xFFD6334B);
  static const Color iconRed = Color(0xFFE25365);
  
  static const Color white = Colors.white;
  static const Color backgroundLight = Color(0xFFFDE8EA);
  
  static const Color cardColor = Color(0xFFEFAFB7); // Color visible on the card
  static const Color fieldColor = Color(0xFFF8E0E3);
  
  static const Color translucentWhite = Color(0xB3FFFFFF); // 70% opacity white
  static const Color translucentBorder = Color(0x4DFFFFFF); // 30% opacity
}
