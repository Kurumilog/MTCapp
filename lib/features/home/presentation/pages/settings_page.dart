/// 1) Общее назначение:
///    Экран настроек приложения (Material 3). Позволяет изменять язык интерфейса.
/// 2) С какими файлами связан:
///    - Открывается из MorePage.
///    - lib/core/l10n/locale_provider.dart — смена локали.
/// 3) Описание функций:
///    - _showLanguagePicker(): BottomSheet выбора языка (RU/EN).
library;
import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../main.dart' show localeProvider;
import 'edit_profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

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
              child: Icon(Icons.manage_accounts_outlined, color: colorScheme.primary, size: 22),
            ),
            title: Text(l10n.editProfile),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            ),
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
              child: Icon(Icons.language_rounded, color: colorScheme.primary, size: 22),
            ),
            title: Text(l10n.appLanguage),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onTap: () => _showLanguagePicker(context, l10n),
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
                  isSelected: Localizations.localeOf(context).languageCode == 'ru',
                ),
                _languageTile(
                  context: context,
                  label: l10n.english,
                  locale: const Locale('en'),
                  isSelected: Localizations.localeOf(context).languageCode == 'en',
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
        localeProvider.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}
