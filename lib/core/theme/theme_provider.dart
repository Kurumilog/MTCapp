/// 1) Общее назначение:
///    Управляет состоянием темы приложения (светлая/тёмная).
/// 2) С какими файлами связан:
///    - `main.dart` (передаёт `themeMode` в MaterialApp).
///    - `settings_page.dart` (переключение темы пользователем).
/// 3) Описание функций:
///    - `ThemeProvider`: ChangeNotifier, хранит текущий `ThemeMode`.
///    - `setThemeMode()`: меняет режим темы и уведомляет слушателей.
library;

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }
}
