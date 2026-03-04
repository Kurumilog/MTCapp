/// 1) Общее назначение:
///    Главный контейнер приложения после авторизации (Material 3).
///    Управляет NavigationBar и переключением между основными разделами.
/// 2) С какими файлами связан:
///    - favorites_page, gallery_page, collections_page, more_page
/// 3) Описание функций:
///    - _onDestinationSelected(): переключение вкладок.
///    - _showAddSheet(): BottomSheet добавления файлов (камера / галерея / файлы).
library;

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../providers/corporate_cloud_stub_provider.dart';
import 'files_page.dart';
import 'more_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [FilesPage(), MorePage()];

  bool get _isWindowsPopup =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  void _showAddSheet() {
    if (_isWindowsPopup) {
      _showWindowsDropDialog();
      return;
    }

    _showMobileAddSheet();
  }

  Future<void> _showMobileAddSheet() async {
    final l10n = AppLocalizations.of(context);

    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(l10n.takePhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(l10n.chooseFromGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.description_rounded,
                      color: Theme.of(context).colorScheme.primary),
                  title: Text(l10n.uploadFile),
                  onTap: () {
                    Navigator.pop(context);
                    _pickFiles();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takePhoto() async {
    final l10n = AppLocalizations.of(context);
    final picker = ImagePicker();

    try {
      final photo = await picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final names = [photo.name];
      await ref.read(corporateCloudProvider.notifier).uploadFiles(names);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.uploadSuccess(names.length))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.error)),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    final l10n = AppLocalizations.of(context);
    final picker = ImagePicker();

    try {
      final images = await picker.pickMultiImage();
      if (images.isEmpty) return;

      final names = images
          .map((image) => image.name)
          .where((name) => name.trim().isNotEmpty)
          .toList();
      await ref.read(corporateCloudProvider.notifier).uploadFiles(names);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.uploadSuccess(names.length))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.error)),
      );
    }
  }

  Future<void> _pickFiles() async {
    final l10n = AppLocalizations.of(context);

    try {
      final selected = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (selected == null || selected.files.isEmpty) return;

      final names = selected.files
          .map((file) => file.name)
          .where((name) => name.trim().isNotEmpty)
          .toList();
      await ref.read(corporateCloudProvider.notifier).uploadFiles(names);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.uploadSuccess(names.length))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.error)),
      );
    }
  }

  Future<void> _showWindowsDropDialog() async {
    final l10n = AppLocalizations.of(context);
    List<String> droppedNames = [];

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.uploadDropTitle),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropTarget(
                      onDragDone: (details) {
                        setDialogState(() {
                          droppedNames = details.files
                              .map((file) => file.name)
                              .where((name) => name.trim().isNotEmpty)
                              .toList();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 30,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.file_upload_outlined, size: 36),
                            const SizedBox(height: 10),
                            Text(
                              l10n.uploadDropHint,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          final picked = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                          );
                          if (picked == null || picked.files.isEmpty) return;
                          setDialogState(() {
                            droppedNames = picked.files.map((f) => f.name).toList();
                          });
                        },
                        icon: const Icon(Icons.folder_open_rounded),
                        label: Text(l10n.chooseFile),
                      ),
                    ),
                    if (droppedNames.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${l10n.filesSelected}: ${droppedNames.length}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: droppedNames.isEmpty
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  child: Text(l10n.uploadFile),
                ),
              ],
            );
          },
        );
      },
    );

    if (droppedNames.isEmpty) return;
    await ref.read(corporateCloudProvider.notifier).uploadFiles(droppedNames);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.uploadSuccess(droppedNames.length))),
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
          if (index == 1) {
            _showAddSheet();
          } else {
            setState(() => _currentIndex = index < 1 ? index : index - 1);
          }
        },
        l10n: l10n,
      ),
    );
  }
}

/// Кастомный нижний навбар: 3 позиции в одну линию.
/// Позиция 1 — кнопка «+».
class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
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

    final iconSize = (size.width * 0.072).clamp(26.0, 36.0);
    final fontSize = (size.width * 0.031).clamp(11.0, 15.0);
    final barHeight = (size.height * 0.095).clamp(68.0, 88.0);
    final fabSize = (size.width * 0.135).clamp(50.0, 64.0);
    final fabRadius = fabSize * 0.3;

    final items = [
      _NavItem(
        icon: Icons.folder_outlined,
        activeIcon: Icons.folder_rounded,
        label: l10n.filesTab,
        pageIndex: 0,
        visualIndex: 0,
      ),
      null, // «+» кнопка
      _NavItem(
        icon: Icons.more_horiz_rounded,
        activeIcon: Icons.more_horiz_rounded,
        label: l10n.more,
        pageIndex: 1,
        visualIndex: 2,
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
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => onTap(1),
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
