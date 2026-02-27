/// 1) Общее назначение:
///    Переиспользуемое поле ввода на основе Material 3 TextField.
///    Стиль берётся из inputDecorationTheme (app_theme.dart).
/// 2) С какими файлами связан:
///    - Используется на LoginPage и RegistrationPage.
/// 3) Описание функций:
///    - build(): TextField с prefixIcon и hintText, стилизованный по M3.
library;
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;

  const AuthTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
