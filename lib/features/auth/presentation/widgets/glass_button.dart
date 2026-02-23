/**
 * 1) Общее назначение:
 *    Переиспользуемая кнопка с эффектом полупрозрачного стекла для форм.
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (цвета стекла и текста)
 *    - Используется на RegistrationPage, LoginPage, WelcomePage.
 * 3) Описание функций:
 *    - build(): Отрисовывает контейнер со скругленными краями (таблетка) и 
 *      полупрозрачным белым фоном. Содержит отцентрированный текст и обрабатывает нажатия (onPressed).
 */
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GlassButton({
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
        child: CNButton(
          label: text,
          onPressed: onPressed,
          style: CNButtonStyle.prominentGlass,
          tint: const Color(0xFFF00303),
          height: 60,
        ),
      ),
    );
  }
}
