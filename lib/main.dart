/**
 * 1) Общее назначение:
 *    Точка входа (entrypoint) во Flutter приложение "MTC Cloud".
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_theme.dart (настройка глобальной темы)
 *    - lib/features/auth/presentation/pages/welcome_page.dart (стартовый экран)
 * 3) Описание функций:
 *    - main(): Запускает приложение вызовом runApp(MyApp()).
 *    - MyApp.build(): Конфигурирует корневой виджет MaterialApp, задает тему и начальный экран (WelcomePage).
 */
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MTC Cloud',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
