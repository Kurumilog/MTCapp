/**
 * 1) Общее назначение:
 *    Приветственный экран приложения "MTC Cloud", который встречает пользователя при первом запуске.
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (цвета)
 *    - lib/core/widgets/auth_background.dart (базовый фон страниц)
 *    - lib/features/auth/presentation/widgets/auth_button.dart (кнопки авторизации)
 *    - lib/features/auth/presentation/pages/registration_page.dart (навигация)
 *    - lib/features/auth/presentation/pages/login_page.dart (навигация)
 * 3) Описание функций:
 *    - build(): Отрисовывает интерфейс приветственного экрана. Показывает логотип,
 *      приветственный текст, две кнопки (Регистрация, Войти) и ссылки внизу.
 */
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_background.dart';
import '../widgets/auth_button.dart';
import 'registration_page.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                
                // MTC Cloud Logo Large
                Icon(Icons.cloud_rounded, color: AppColors.primaryRed, size: 100),
                const SizedBox(height: 20),
                
                Text(
                  'Добро пожаловать в\nMTC Cloud',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                    color: AppColors.primaryRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 20),
                
                Text(
                  'Здесь вы можете надежно хранить свои данные, синхронизировать устройства и получать доступ к файлам из любой точки мира.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(flex: 2),
                
                // Buttons
                AuthButton(
                  text: 'Регистрация',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 10),
                
                AuthButton(
                  text: 'Войти',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                
                const Spacer(flex: 1),
                
                // Temporary skip button (until registration works)
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: const Text('Пропустить'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Footer Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Задать вопросы',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Перейти на сайт',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
