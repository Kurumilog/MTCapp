/// 1) Общее назначение:
///    Управляет состоянием выбранного языка (Locale) в приложении.
/// 2) С какими файлами связан:
///    - lib/main.dart (используется для перестроения приложения при смене языка)
///    - lib/features/home/presentation/pages/settings_page.dart (вызывает смену языка)
/// 3) Описание функций:
///    - LocaleProvider: ChangeNotifier, хранящий текущую локаль.
///    - setLocale(): Метод для обновления локали и уведомления слушателей.
library;

import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ru');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
