/**
 * 1) Общее назначение:
 *    Главный экран регистрации нового пользователя в приложении "MTC Cloud".
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (цвета)
 *    - lib/core/widgets/glass_background.dart (задний фон с эффектом стекла)
 *    - lib/features/auth/presentation/widgets/glass_text_field.dart (текстовые поля)
 *    - lib/features/auth/presentation/widgets/glass_button.dart (кнопка)
 * 3) Описание функций:
 *    - build(): Отрисовывает интерфейс экрана. Собирает вместе логотип, форму(с полями 
 *      ФИО, Телефон, Email, и кнопкой "Зарегистрироваться") и ссылку на вход.
 */
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_background.dart';
import '../widgets/glass_text_field.dart';
import '../widgets/glass_button.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GlassBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                
                // MTC Cloud Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_rounded, color: AppColors.primaryRed, size: 40),
                    const SizedBox(width: 10),
                    Text(
                      'MTC Cloud',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 32,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Main Glass Card
                ClipRRect(
                  borderRadius: BorderRadius.circular(42),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF545454).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(42),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                      ),
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 30.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title Pill
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: AppColors.glassWhite,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Зарегистрируйтесь',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 24,
                              color: AppColors.primaryRed,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        const GlassTextField(
                          hintText: 'ФИО',
                          icon: Icons.person_rounded,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const GlassTextField(
                          hintText: 'Номер телефона',
                          icon: Icons.phone_rounded,
                        ),
                        const GlassTextField(
                          hintText: 'Электронная почта',
                          icon: Icons.email_rounded,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        GlassButton(
                          text: 'Зарегистрироваться',
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Login prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Уже зарегистрированы? ',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey, // Изменено на серый
                        fontSize: 16, // Уменьшен шрифт
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login'); // just placeholder since we don't have routing exactly set yet, wait actually we can just use pop or push.
                      },
                      child: Text(
                        'Войти',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey.shade600, // Серый темнее для ссылки
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
