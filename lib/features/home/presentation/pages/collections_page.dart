/// 1) Общее назначение:
///    Экран «Коллекции» — сгруппированные файлы/альбомы (Material 3, stub).
/// 2) С какими файлами связан:
///    - Встраивается в HomePage.
library;

import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_rounded,
              size: (size.width * 0.2).clamp(60.0, 120.0),
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
            SizedBox(height: size.height * 0.02),
            Text(l10n.collectionsTitle, style: textTheme.headlineMedium),
            SizedBox(height: size.height * 0.01),
            Text(
              l10n.collectionsSubtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
