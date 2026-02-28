/// 1) Общее назначение:
///    Экран настроек приложения (Material 3). Личные данные, язык, выход.
/// 2) С какими файлами связан:
///    - Открывается из MorePage.
///    - lib/core/l10n/locale_provider.dart — смена локали.
///    - lib/features/auth/presentation/providers/auth_provider.dart — выход.
/// 3) Описание функций:
///    - _showLanguagePicker(): BottomSheet выбора языка (RU/EN).
///    - _handleLogout(): Диалог подтверждения → очистка storage → навигация на WelcomePage.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../main.dart' show localeProvider;
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/welcome_page.dart';
import '../providers/user_provider.dart';
import 'edit_profile_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authNotifierProvider);
    final isLoggedIn = authState is AuthAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.manage_accounts_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            title: Text(l10n.editProfile),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
              if (result == true) {
                ref.invalidate(userProvider);
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.language_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            title: Text(l10n.appLanguage),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () => _showLanguagePicker(context, l10n),
          ),
          if (isLoggedIn) ...[
            const Divider(height: 40),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: colorScheme.error,
                  size: 22,
                ),
              ),
              title: Text(
                l10n.logout,
                style: TextStyle(color: colorScheme.error),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () => _handleLogout(context, ref, l10n),
            ),
          ],
        ],
      ),
    );
  }

  void _handleLogout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logout),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
            onPressed: () async {
              Navigator.pop(dialogContext); // Закрываем диалог

              // Выход: очищаем токены, userId из storage + сбрасываем состояние
              await ref.read(authNotifierProvider.notifier).logout();

              if (context.mounted) {
                // Сбрасываем весь стек навигации и ставим WelcomePage
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomePage()),
                  (route) => false,
                );
              }
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  l10n.appLanguage,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _languageTile(
                  context: context,
                  label: l10n.russian,
                  locale: const Locale('ru'),
                  isSelected:
                      Localizations.localeOf(context).languageCode == 'ru',
                ),
                _languageTile(
                  context: context,
                  label: l10n.english,
                  locale: const Locale('en'),
                  isSelected:
                      Localizations.localeOf(context).languageCode == 'en',
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _languageTile({
    required BuildContext context,
    required String label,
    required Locale locale,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        // Закрываем BottomSheet, ждем окончания анимации (около 300мс),
        // затем меняем язык. Иначе одновременный rebuild MaterialApp
        // и анимация закрытия вызывают лаги и Duplicate GlobalKey crash.
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          localeProvider.setLocale(locale);
        });
      },
    );
  }
}
