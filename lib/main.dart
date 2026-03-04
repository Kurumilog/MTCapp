/// 1) Общее назначение:
///    Точка входа (entrypoint) во Flutter приложение "MTC Cloud".
///    Конфигурирует Riverpod, локализацию, тему и корневой виджет.
///    На Windows запускается в режиме popup-виджета (иконка в трее).
/// 2) С какими файлами связан:
///    - lib/core/theme/app_theme.dart (глобальная тема)
///    - lib/core/l10n/app_localizations.dart (локализация)
///    - lib/core/l10n/locale_provider.dart (управление языком)
///    - lib/features/auth/presentation/providers/auth_provider.dart
///    - lib/features/auth/presentation/pages/welcome_page.dart (стартовый экран)
///    - lib/features/home/presentation/pages/home_page.dart
/// 3) Описание функций:
///    - main(): Инициализация. На Windows настраивает popup-окно и трей.
///    - MyApp: Корневой виджет, слушает смену темы/локали.
///    - AuthGate: Проверяет наличие токенов и решает начальный маршрут.
///    - WindowsPopupWrapper: Управляет иконкой в трее и перехватом закрытия окна.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/l10n/app_localizations.dart';
import 'core/l10n/locale_provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/home/presentation/pages/import_by_link_page.dart';
import 'features/home/presentation/providers/corporate_cloud_stub_provider.dart';

final localeProvider = LocaleProvider();
final themeProvider = ThemeProvider();

// Размер popup-окна на Windows
const _kPopupWidth = 360.0;
const _kPopupHeight = 600.0;

bool get _isWindows =>
    !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_isWindows) {
    await _initWindowsPopup();
  }

  runApp(const ProviderScope(child: MyApp()));
}

/// Инициализирует окно и трей для Windows popup-режима.
Future<void> _initWindowsPopup() async {
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(_kPopupWidth, _kPopupHeight),
    maximumSize: Size(_kPopupWidth, _kPopupHeight),
    minimumSize: Size(_kPopupWidth, _kPopupHeight),
    skipTaskbar: true,
    title: 'MTC Cloud',
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Запрет реального закрытия — вместо него будем скрывать в трей
    await windowManager.setPreventClose(true);
    // Окно нельзя перетаскивать — фиксированная позиция у трея
    await windowManager.setMovable(false);
    await _positionNearTray();
    await windowManager.show();
    await windowManager.focus();
  });
}

/// Позиционирует окно в правом нижнем углу экрана (рядом с треем).
Future<void> _positionNearTray() async {
  try {
    final display = await screenRetriever.getPrimaryDisplay();
    const margin = 12.0;
    const taskbarHeight = 50.0;
    final x = display.size.width - _kPopupWidth - margin;
    final y =
        display.size.height - _kPopupHeight - taskbarHeight - margin;
    await windowManager.setPosition(Offset(x, y));
  } catch (_) {
    // Если не удалось получить размер экрана — оставляем позицию по умолчанию
  }
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
          home: _isWindows
              ? const WindowsPopupWrapper(child: AuthGate())
              : const AuthGate(),
        );
      },
    );
  }
}

/// Прозрачный wrapper для Windows:
/// — Регистрирует иконку в системном трее.
/// — Клик по иконке = показать/скрыть окно.
/// — Закрытие окна (крестик) = скрыть в трей (не завершать процесс).
/// — Пункт меню «Выйти» завершает приложение.
class WindowsPopupWrapper extends StatefulWidget {
  final Widget child;

  const WindowsPopupWrapper({super.key, required this.child});

  @override
  State<WindowsPopupWrapper> createState() => _WindowsPopupWrapperState();
}

class _WindowsPopupWrapperState extends State<WindowsPopupWrapper>
    with TrayListener, WindowListener {
  @override
  void initState() {
    super.initState();
    trayManager.addListener(this);
    windowManager.addListener(this);
    _setupTray();
  }

  @override
  void dispose() {
    trayManager.removeListener(this);
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _setupTray() async {
    // Иконка приложения из ресурсов Windows runner.
    // Для production: замените на файл .ico (32×32 или 256×256).
    await trayManager.setIcon(
      'windows/runner/resources/app_icon.ico',
    );
    await trayManager.setToolTip('MTC Cloud');

    final menu = Menu(
      items: [
        MenuItem(label: 'MTC Cloud', disabled: true),
        MenuItem.separator(),
        MenuItem(key: 'show_hide', label: 'Показать / Скрыть'),
        MenuItem.separator(),
        MenuItem(key: 'exit', label: 'Выйти'),
      ],
    );
    await trayManager.setContextMenu(menu);
  }

  // ─── TrayListener ────────────────────────────────────
  @override
  void onTrayIconMouseDown() => _toggleVisibility();

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {
    if (menuItem.key == 'show_hide') {
      _toggleVisibility();
    } else if (menuItem.key == 'exit') {
      _exitApp();
    }
  }

  // ─── WindowListener ──────────────────────────────────
  @override
  void onWindowClose() => _hideToTray();

  // ─── Helpers ─────────────────────────────────────────
  Future<void> _toggleVisibility() async {
    final visible = await windowManager.isVisible();
    if (visible) {
      await _hideToTray();
    } else {
      await _showFromTray();
    }
  }

  Future<void> _hideToTray() async {
    await windowManager.hide();
  }

  Future<void> _showFromTray() async {
    await _positionNearTray();
    await windowManager.show();
    await windowManager.focus();
  }

  Future<void> _exitApp() async {
    await trayManager.destroy();
    await windowManager.setPreventClose(false);
    await windowManager.close();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Проверяет состояние авторизации при старте:
/// если авторизован и подключён к корпоративному облаку — HomePage,
/// если авторизован, но не подключён — ImportByLinkPage,
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
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final hasCorporateAccess = ref.watch(
      corporateCloudProvider.select((state) => state.hasCorporateAccess),
    );

    return switch (authState) {
      AuthInitial() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      AuthAuthenticated() => hasCorporateAccess
          ? const HomePage()
          : const ImportByLinkPage(),
      _ => const WelcomePage(),
    };
  }
}
