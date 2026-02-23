/**
 * 1) Общее назначение:
 *    Переиспользуемое поле ввода текста с эффектом стекла и иконкой.
 * 2) С какими файлами связан:
 *    - lib/core/theme/app_colors.dart (цвета)
 *    - Используется на RegistrationPage и LoginPage.
 * 3) Описание функций:
 *    - build(): Отрисовывает TextField без стандартных границ внутри контейнера-таблетки.
 *      Отображает hintText (подсказку) и иконку (icon) справа.
 */
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GlassTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextCapitalization textCapitalization;

  const GlassTextField({
    Key? key,
    required this.hintText,
    required this.icon,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.glassWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
            child: TextField(
              textCapitalization: textCapitalization,
              style: const TextStyle(color: AppColors.textRed, fontSize: 18),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.cardColor, fontSize: 18),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 30, top: 22, bottom: 22),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(icon, color: AppColors.iconRed, size: 36),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
