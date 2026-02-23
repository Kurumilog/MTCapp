/// Экран «Коллекции» — показывает группировки/альбомы файлов.
/// Пока что заглушка с иконкой и текстом.
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_rounded, size: 80, color: AppColors.primaryRed.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Коллекции',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь будут ваши альбомы',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
