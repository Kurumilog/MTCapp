/// 1) Общее назначение:
///    Главный контейнер приложения после авторизации (Material 3).
///    Управляет NavigationBar и переключением между основными разделами.
/// 2) С какими файлами связан:
///    - favorites_page, gallery_page, collections_page, more_page
/// 3) Описание функций:
///    - _onDestinationSelected(): переключение вкладок.
///    - _showAddSheet(): BottomSheet добавления файлов (камера / галерея / файлы).
library;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'favorites_page.dart';
import 'gallery_page.dart';
import 'collections_page.dart';
import 'more_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _imagePicker = ImagePicker();

  // 4 реальных вкладки: Любимое / Галерея / Коллекции / Ещё
  // Кнопка «+» — FAB, не вкладка
  final List<Widget> _pages = const [
    FavoritesPage(),
    GalleryPage(),
    CollectionsPage(),
    MorePage(),
  ];

  void _showAddSheet() {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  l10n.addTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                _buildAddOption(
                  icon: Icons.photo_camera_outlined,
                  label: l10n.takePhoto,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    nav.pop();
                    await _imagePicker.pickImage(source: ImageSource.camera);
                  },
                ),
                _buildAddOption(
                  icon: Icons.photo_library_outlined,
                  label: l10n.chooseFromGallery,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    nav.pop();
                    await _imagePicker.pickMultiImage();
                  },
                ),
                _buildAddOption(
                  icon: Icons.upload_file_outlined,
                  label: l10n.uploadFile,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    nav.pop();
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right_rounded),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_rounded, color: colorScheme.primary, size: 28),
            const SizedBox(width: 8),
            Text(l10n.appTitle),
          ],
        ),
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _showAddSheet();
          } else {
            setState(() => _currentIndex = index < 2 ? index : index - 1);
          }
        },
        l10n: l10n,
      ),
    );
  }
}

/// Кастомный нижний навбар: 5 позиций в одну линию.
/// Позиция 2 — кнопка «+» (не вкладка, вызывает BottomSheet).
class _BottomNavBar extends StatelessWidget {
  final int currentIndex; // 0..3 (индекс страницы, без учёта «+»)
  final ValueChanged<int> onTap; // передаёт 0..4 (с учётом «+» в центре)
  final AppLocalizations l10n;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.sizeOf(context);

    // Адаптивные размеры: иконки ~7% ширины экрана, шрифт ~3%, высота бара ~10%
    final iconSize = (size.width * 0.072).clamp(26.0, 36.0);
    final fontSize = (size.width * 0.031).clamp(11.0, 15.0);
    final barHeight = (size.height * 0.095).clamp(68.0, 88.0);
    final fabSize = (size.width * 0.135).clamp(50.0, 64.0);
    final fabRadius = fabSize * 0.3;

    // Маппинг: визуальные индексы 0,1,_,3,4 → страницы 0,1,_,2,3
    final items = [
      _NavItem(
        icon: Icons.star_outline_rounded,
        activeIcon: Icons.star_rounded,
        label: l10n.favorites,
        pageIndex: 0,
        visualIndex: 0,
      ),
      _NavItem(
        icon: Icons.photo_library_outlined,
        activeIcon: Icons.photo_library_rounded,
        label: l10n.gallery,
        pageIndex: 1,
        visualIndex: 1,
      ),
      null, // «+» кнопка
      _NavItem(
        icon: Icons.folder_outlined,
        activeIcon: Icons.folder_rounded,
        label: l10n.collections,
        pageIndex: 2,
        visualIndex: 3,
      ),
      _NavItem(
        icon: Icons.more_horiz_rounded,
        activeIcon: Icons.more_horiz_rounded,
        label: l10n.more,
        pageIndex: 3,
        visualIndex: 4,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: barHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < items.length; i++)
                if (items[i] == null)
                  // Кнопка «+»
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => onTap(2),
                        child: Container(
                          width: fabSize,
                          height: fabSize,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(fabRadius),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.22,
                                ),
                                blurRadius: fabSize * 0.75,
                                spreadRadius: fabSize * 0.04,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: colorScheme.onPrimary,
                            size: iconSize * 1.1,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  // Обычная вкладка
                  Expanded(
                    child: InkWell(
                      onTap: () => onTap(i),
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            currentIndex == items[i]!.pageIndex
                                ? items[i]!.activeIcon
                                : items[i]!.icon,
                            size: iconSize,
                            color: currentIndex == items[i]!.pageIndex
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(height: size.height * 0.003),
                          Text(
                            items[i]!.label,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontSize: fontSize,
                                  color: currentIndex == items[i]!.pageIndex
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                  fontWeight:
                                      currentIndex == items[i]!.pageIndex
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int pageIndex;
  final int visualIndex;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.pageIndex,
    required this.visualIndex,
  });
}
