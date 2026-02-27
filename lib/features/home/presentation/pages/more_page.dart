/// 1) Общее назначение:
///    Экран «Ещё» — профиль пользователя + дополнительное меню (Material 3).
/// 2) С какими файлами связан:
///    - Встраивается в HomePage.
///    - Переход на settings_page.dart.
///    - lib/features/home/presentation/providers/user_provider.dart
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../providers/user_provider.dart';
import 'settings_page.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final userAsync = ref.watch(userProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        _buildProfileHeader(context, colorScheme, l10n, userAsync),
        const Divider(height: 32),
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

  Widget _buildProfileHeader(
    BuildContext context,
    ColorScheme colorScheme,
    AppLocalizations l10n,
    AsyncValue<UserModel?> userAsync,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(
            l10n.profile,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 44,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          userAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (_, e) => _buildLoginPrompt(context, l10n, colorScheme, textTheme),
            data: (user) => user != null
                ? _buildUserInfo(context, colorScheme, user)
                : _buildLoginPrompt(context, l10n, colorScheme, textTheme),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(
    BuildContext context,
    ColorScheme colorScheme,
    UserModel user,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final nameParts = [user.lastName, user.firstName];
    if (user.surName != null && user.surName!.isNotEmpty) {
      nameParts.add(user.surName!);
    }
    final fullName = nameParts.join(' ');

    return Column(
      children: [
        Text(
          fullName,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '@${user.username}',
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
        ),
        if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) ...[  
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_outlined, size: 14, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                user.phoneNumber!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email_outlined, size: 14, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              user.email,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginPrompt(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return TextButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage(popOnSuccess: true)),
      ),
      icon: Icon(Icons.login_rounded, size: 18, color: colorScheme.primary),
      label: Text(
        l10n.loginToSeeProfile,
        style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
      ),
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
