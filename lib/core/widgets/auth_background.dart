/// 1) Общее назначение:
///    Виджет-обёртка для экранов авторизации: чистый белый фон (Material 3).
/// 2) С какими файлами связан:
///    - Используется на WelcomePage, LoginPage, RegistrationPage.
/// 3) Описание функций:
///    - isReversed: зарезервировано для будущих декоративных вариантов.
library;

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  final bool isReversed;

  const AuthBackground({
    super.key,
    required this.child,
    this.isReversed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }
}
