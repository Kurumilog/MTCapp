/// 1) Общее назначение:
///    Приветственный экран приложения "MTC Cloud" (стиль Material 3).
/// 2) С какими файлами связан:
///    - lib/features/auth/presentation/widgets/auth_button.dart
///    - lib/features/auth/presentation/pages/registration_page.dart
///    - lib/features/auth/presentation/pages/login_page.dart
///    - lib/features/home/presentation/pages/home_page.dart
/// 3) Описание функций:
///    - build(): Логотип, приветственный текст, FilledButton + OutlinedButton, ссылки внизу.
library;

import 'package:flutter/material.dart';
import '../widgets/auth_button.dart';
import 'registration_page.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 1),

              // Logo
              Icon(Icons.cloud_rounded, color: colorScheme.primary, size: 96),
              const SizedBox(height: 24),

              Text(
                'Добро пожаловать в\nMTC Cloud',
                style: textTheme.displaySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'Здесь вы можете надёжно хранить свои данные, синхронизировать устройства и получать доступ к файлам из любой точки мира.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Primary action
              AuthButton(
                text: 'Регистрация',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegistrationPage()),
                ),
              ),

              // Secondary action
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    child: const Text('Войти'),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Temp skip
              TextButton.icon(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomePage()),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Пропустить'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    child: const Text('Задать вопросы'),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.onSurfaceVariant,
                    ),
                    child: const Text('Перейти на сайт'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
