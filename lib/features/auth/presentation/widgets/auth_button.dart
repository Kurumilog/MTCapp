/// 1) Общее назначение:
///    Переиспользуемая кнопка авторизации на основе Material 3 FilledButton.
/// 2) С какими файлами связан:
///    - Используется на WelcomePage, LoginPage, RegistrationPage.
/// 3) Описание функций:
///    - build(): FilledButton на всю ширину с фирменным красным цветом MTC.
library;
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton(
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }
}
