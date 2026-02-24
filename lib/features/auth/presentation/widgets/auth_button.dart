/**
 * 1) Общее назначение:
 *    Переиспользуемая кнопка с фирменным красным стилем MTC для форм авторизации.
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (цвета кнопки)
 *    - Используется на RegistrationPage, LoginPage, WelcomePage.
 * 3) Описание функций:
 *    - build(): Отрисовывает кнопку-таблетку на всю ширину с текстом и обработкой нажатий (onPressed).
 */
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
