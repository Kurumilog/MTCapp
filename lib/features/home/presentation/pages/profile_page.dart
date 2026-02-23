/// Экран «Профиль» — показывает настройки и информацию о пользователе.
/// Пока что заглушка с аватаром и текстом.
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.primaryRed.withValues(alpha: 0.1),
            child: Icon(Icons.person_rounded, size: 60, color: AppColors.primaryRed),
          ),
          const SizedBox(height: 16),
          Text(
            'Профиль',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Настройки аккаунта',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
