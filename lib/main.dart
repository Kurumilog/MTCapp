/// 1) Общее назначение:
///    Точка входа (entrypoint) во Flutter приложение "MTC Cloud".
///    Конфигурирует Riverpod, локализацию, тему и корневой виджет.
/// 2) С какими файлами связан:
///    - lib/core/theme/app_theme.dart (глобальная тема)
///    - lib/core/l10n/app_localizations.dart (локализация)
///    - lib/core/l10n/locale_provider.dart (управление языком)
///    - lib/features/auth/presentation/providers/auth_provider.dart
///    - lib/features/auth/presentation/pages/welcome_page.dart (стартовый экран)
///    - lib/features/home/presentation/pages/home_page.dart
/// 3) Описание функций:
///    - main(): Инициализация и запуск приложения.
///    - MyApp: Корневой StatelessWidget, слушающий смену локали.
///    - AuthGate: Проверяет наличие токенов и решает начальный маршрут.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/home_page.dart';

final localeProvider = LocaleProvider();
final themeProvider = ThemeProvider();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([localeProvider, themeProvider]),
      builder: (context, _) {
        return MaterialApp(
          title: 'MTC Cloud',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          locale: localeProvider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AuthGate(),
        );
      },
    );
  }
}

/// Проверяет состояние авторизации при старте:
/// если есть сохранённые токены — сразу HomePage,
/// иначе — WelcomePage.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  @override
  void initState() {
    super.initState();
    // Проверяем токены при старте
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return switch (authState) {
      AuthInitial() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthAuthenticated() => const HomePage(),
      _ => const WelcomePage(),
    };
  }
}
