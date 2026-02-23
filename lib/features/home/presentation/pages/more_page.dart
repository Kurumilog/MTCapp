/**
 * 1) Общее назначение:
 *    Экран «Ещё» — дополнительное меню приложения (настройки, корзина и пр.).
 * 2) С какими файлами связан:
 *    - Встраивается в HomePage.
 *    - Переход на lib/features/home/presentation/pages/settings_page.dart.
 * 3) Описание функций:
 *    - MorePage: StatelessWidget, список пунктов меню.
 *    - _buildMenuItem(): Вспомогательный метод для создания строки меню.
 */
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'settings_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);
    final tilePadding = EdgeInsets.symmetric(
      horizontal: size.width * 0.04,
      vertical: size.height * 0.004,
    );

    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.02,
      ),
      children: [
        // Settings
        _buildMenuItem(
          context: context,
          icon: Icons.settings_rounded,
          label: l10n.settings,
          padding: tilePadding,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            );
          },
        ),
        const Divider(height: 1),

        // Trash — coming soon
        _buildMenuItem(
          context: context,
          icon: Icons.delete_outline_rounded,
          label: l10n.trash,
          padding: tilePadding,
          trailing: _comingSoonBadge(context, l10n),
        ),
        const Divider(height: 1),

        // Download folder/file — coming soon
        _buildMenuItem(
          context: context,
          icon: Icons.download_rounded,
          label: l10n.download,
          padding: tilePadding,
          trailing: _comingSoonBadge(context, l10n),
        ),
        const Divider(height: 1),

        // Cloud import — coming soon
        _buildMenuItem(
          context: context,
          icon: Icons.cloud_download_outlined,
          label: l10n.cloudImport,
          padding: tilePadding,
          trailing: _comingSoonBadge(context, l10n),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required EdgeInsets padding,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: padding,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primaryRed),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _comingSoonBadge(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        l10n.comingSoon,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
