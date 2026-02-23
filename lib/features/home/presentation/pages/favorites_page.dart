/**
 * 1) Общее назначение:
 *    Экран «Избранное» — отображает файлы, отмеченные пользователем как важные.
 * 2) С какими файлами связан:
 *    - Встраивается в HomePage.
 * 3) Описание функций:
 *    - FavoritesPage: StatelessWidget, отображающий заглушку с иконкой звезды.
 */
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final iconSize = size.width * 0.2;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_rounded,
              size: iconSize.clamp(60.0, 120.0),
              color: AppColors.primaryRed.withValues(alpha: 0.3),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              l10n.favoritesTitle,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black54,
                  ),
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              l10n.favoritesSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
