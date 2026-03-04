/// 1) Общее назначение:
///    Виджет-обёртка для экранов авторизации: чистый белый фон (Material 3).
///    Зарезервирован для будущего использования (декоративный фон, градиент и т.п.).
/// 2) С какими файлами связан:
///    - Пока не используется ни в одном файле (задел для Phase B/C).
/// 3) Описание параметров:
///    - child: виджет-содержимое, которое будет обёрнуто.
///    - isReversed: зарезервировано для будущих декоративных вариантов.
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
