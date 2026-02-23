/// Главный экран приложения с нижней навигационной панелью.
/// Содержит 4 вкладки: Галерея, Коллекции, Добавить, Профиль.
/// Связан с: gallery_page.dart, collections_page.dart, profile_page.dart.
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'gallery_page.dart';
import 'collections_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    GalleryPage(),
    CollectionsPage(),
    SizedBox.shrink(), // Placeholder for Add action
    ProfilePage(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      // "Add" button — show a bottom sheet
      _showAddSheet();
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                const SizedBox(height: 24),
                Text(
                  'Добавить',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                _buildAddOption(
                  icon: Icons.photo_camera_rounded,
                  label: 'Сделать фото',
                  onTap: () => Navigator.pop(context),
                ),
                _buildAddOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Выбрать из галереи',
                  onTap: () => Navigator.pop(context),
                ),
                _buildAddOption(
                  icon: Icons.upload_file_rounded,
                  label: 'Загрузить файл',
                  onTap: () => Navigator.pop(context),
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
            Icon(Icons.cloud_rounded, color: AppColors.primaryRed, size: 28),
            const SizedBox(width: 8),
            Text(
              'MTC Cloud',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex < 2 ? _currentIndex : _currentIndex - 1,
        children: const [
          GalleryPage(),
          CollectionsPage(),
          ProfilePage(),
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.photo_library_outlined, Icons.photo_library_rounded, 'Галерея'),
                _buildNavItem(1, Icons.folder_outlined, Icons.folder_rounded, 'Коллекции'),
                _buildAddButton(),
                _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, 'Профиль'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
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
                size: 26,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? AppColors.primaryRed : Colors.grey,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _onTabTapped(2),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF3B30), Color(0xFFE30613)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryRed.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
