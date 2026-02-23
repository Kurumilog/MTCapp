/// Экран «Галерея» — показывает сетку файлов/медиа пользователя.
/// Пока что заглушка с иконкой и текстом.
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_rounded, size: 80, color: AppColors.primaryRed.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Галерея',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь будут ваши файлы',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
