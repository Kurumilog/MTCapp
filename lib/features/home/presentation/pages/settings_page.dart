/**
 * 1) Общее назначение:
 *    Экран настроек приложения. Позволяет изменять язык интерфейса.
 * 2) С какими файлами связан:
 *    - Открывается из MorePage.
 *    - Взаимодействует с lib/core/l10n/locale_provider.dart.
 * 3) Описание функций:
 *    - SettingsPage: StatelessWidget, отображающий список настроек.
 *    - _showLanguagePicker(): Вызывает диалог выбора языка (RU/EN).
 */
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../main.dart' show localeProvider;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        title: Text(
          l10n.settingsTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.language_rounded,
                  color: AppColors.primaryRed),
            ),
            title: Text(l10n.appLanguage,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500)),
            trailing:
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            onTap: () => _showLanguagePicker(context, l10n),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.appLanguage,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.primaryRed : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryRed)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        localeProvider.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}
