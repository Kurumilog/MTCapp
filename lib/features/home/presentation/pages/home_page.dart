/**
 * 1) Общее назначение:
 *    Главный контейнер приложения после авторизации.
 *    Управляет нижней навигацией и переключением между основными разделами.
 * 2) С какими файлами связан:
 *    - lib/features/home/presentation/pages/favorites_page.dart
 *    - lib/features/home/presentation/pages/gallery_page.dart
 *    - lib/features/home/presentation/pages/collections_page.dart
 *    - lib/features/home/presentation/pages/more_page.dart
 * 3) Описание функций:
 *    - HomePage: StatefulWidget, хранящий индекс текущей вкладки.
 *    - _showAddSheet(): Отображает меню добавления файлов (фото, галерея, файлы).
 */
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

  // Indices: 0=Favorites, 1=Gallery, 2=Add(action), 3=Collections, 4=More
  // Pages mapped: 0→Favorites, 1→Gallery, 2→Collections, 3→More
  final List<Widget> _pages = const [
    FavoritesPage(),
    GalleryPage(),
    CollectionsPage(),
    MorePage(),
  ];

  int get _pageIndex {
    if (_currentIndex < 2) return _currentIndex;
    return _currentIndex - 1; // skip index 2 (Add button)
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      _showAddSheet();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _showAddSheet() {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.025,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: size.height * 0.025),
                Text(
                  l10n.addTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: size.height * 0.02),
                _buildAddOption(
                  icon: Icons.photo_camera_rounded,
                  label: l10n.takePhoto,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    nav.pop();
                    await _imagePicker.pickImage(source: ImageSource.camera);
                  },
                ),
                _buildAddOption(
                  icon: Icons.photo_library_rounded,
                  label: l10n.chooseFromGallery,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    nav.pop();
                    await _imagePicker.pickMultiImage();
                  },
                ),
                _buildAddOption(
                  icon: Icons.upload_file_rounded,
                  label: l10n.uploadFile,
                  onTap: () async {
                    final nav = Navigator.of(context);
                    nav.pop();
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                  },
                ),
                SizedBox(height: size.height * 0.01),
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
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryRed),
      ),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final navIconSize = (size.width * 0.06).clamp(22.0, 30.0);
    final navFontSize = (size.width * 0.028).clamp(10.0, 13.0);
    final addBtnSize = (size.width * 0.125).clamp(46.0, 60.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_rounded,
                color: AppColors.primaryRed,
                size: (size.width * 0.07).clamp(24.0, 34.0)),
            SizedBox(width: size.width * 0.02),
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
              vertical: size.height * 0.005,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.star_outline_rounded,
                  activeIcon: Icons.star_rounded,
                  label: l10n.favorites,
                  iconSize: navIconSize,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.photo_library_outlined,
                  activeIcon: Icons.photo_library_rounded,
                  label: l10n.gallery,
                  iconSize: navIconSize,
                  fontSize: navFontSize,
                ),
                _buildAddButton(addBtnSize),
                _buildNavItem(
                  index: 3,
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder_rounded,
                  label: l10n.collections,
                  iconSize: navIconSize,
                  fontSize: navFontSize,
                ),
                _buildNavItem(
                  index: 4,
                  icon: Icons.more_horiz_rounded,
                  activeIcon: Icons.more_horiz_rounded,
                  label: l10n.more,
                  iconSize: navIconSize,
                  fontSize: navFontSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required double iconSize,
    required double fontSize,
  }) {
    final isActive = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                color: isActive ? AppColors.primaryRed : Colors.grey,
                size: iconSize,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isActive ? AppColors.primaryRed : Colors.grey,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(double btnSize) {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: btnSize,
        height: btnSize,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF3B30), Color(0xFFE30613)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(btnSize * 0.3),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(Icons.add_rounded, color: Colors.white, size: btnSize * 0.55),
      ),
    );
  }
}
