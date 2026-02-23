/**
 * 1) Общее назначение:
 *    Точка входа (entrypoint) во Flutter приложение "MTC Cloud".
 *    Конфигурирует локализацию, тему и корневой виджет.
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_theme.dart (глобальная тема)
 *    - lib/core/l10n/app_localizations.dart (локализация)
 *    - lib/core/l10n/locale_provider.dart (управление языком)
 *    - lib/features/auth/presentation/pages/welcome_page.dart (стартовый экран)
 * 3) Описание функций:
 *    - main(): Инициализация и запуск приложения.
 *    - MyApp: Корневой StatelessWidget, слушающий смену локали.
 */
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_provider.dart';
import 'features/auth/presentation/pages/welcome_page.dart';

final localeProvider = LocaleProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeProvider,
      builder: (context, _) {
        return MaterialApp(
          title: 'MTC Cloud',
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const WelcomePage(),
        );
      },
    );
  }
}
