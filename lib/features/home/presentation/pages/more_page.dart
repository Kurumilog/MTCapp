/// 1) Общее назначение:
///    Экран «Ещё» — дополнительное меню приложения (Material 3).
/// 2) С какими файлами связан:
///    - Встраивается в HomePage.
///    - Переход на settings_page.dart.
library;
import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'settings_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _buildMenuItem(
          context: context,
          icon: Icons.settings_outlined,
          label: l10n.settings,
          colorScheme: colorScheme,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        ),
        const Divider(),
        _buildMenuItem(
          context: context,
          icon: Icons.delete_outline_rounded,
          label: l10n.trash,
          colorScheme: colorScheme,
          trailing: _comingSoonBadge(context, l10n),
        ),
        const Divider(),
        _buildMenuItem(
          context: context,
          icon: Icons.download_outlined,
          label: l10n.download,
          colorScheme: colorScheme,
          trailing: _comingSoonBadge(context, l10n),
        ),
        const Divider(),
        _buildMenuItem(
          context: context,
          icon: Icons.cloud_download_outlined,
          label: l10n.cloudImport,
          colorScheme: colorScheme,
          trailing: _comingSoonBadge(context, l10n),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colorScheme.primary, size: 22),
      ),
      title: Text(label),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  Widget _comingSoonBadge(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        l10n.comingSoon,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
