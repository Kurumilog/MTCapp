/// 1) Общее назначение:
///    Экран настроек приложения (Material 3). Личные данные, язык, выход.
/// 2) С какими файлами связан:
///    - Открывается из MorePage.
///    - lib/core/l10n/locale_provider.dart — смена локали.
///    - lib/core/theme/theme_provider.dart — смена темы.
///    - lib/features/auth/presentation/providers/auth_provider.dart — выход.
/// 3) Описание функций:
///    - _showLanguagePicker(): BottomSheet выбора языка (RU/EN).
///    - _showThemePicker(): BottomSheet выбора темы (Light/Dark).
///    - _handleLogout(): Диалог подтверждения → очистка storage → навигация на WelcomePage.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../main.dart' show localeProvider, themeProvider;
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/pages/welcome_page.dart';
import '../providers/user_provider.dart';
import 'edit_profile_page.dart';

class SettingsPage extends ConsumerWidget {
  static const Duration _uiSwitchDelay = Duration(milliseconds: 300);

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
                Icons.dark_mode_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            title: Text(l10n.appTheme),
            trailing: const Icon(Icons.chevron_right_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onTap: () => _showThemePicker(context, l10n),
          ),
          if (isLoggedIn) ...[
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
                  Icons.lock_reset_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              title: Text(l10n.changePassword),
              trailing: const Icon(Icons.chevron_right_rounded),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () => _handleChangePassword(context, ref, l10n),
            ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: colorScheme.surface,
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
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
          ),
        ],
      ),
    );
  }

  void _showThemePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  l10n.appTheme,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _themeTile(
                  context: context,
                  label: l10n.lightTheme,
                  mode: ThemeMode.light,
                  isSelected: !isDarkMode,
                ),
                _themeTile(
                  context: context,
                  label: l10n.darkTheme,
                  mode: ThemeMode.dark,
                  isSelected: isDarkMode,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleChangePassword(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final payload = await showDialog<_ChangePasswordPayload>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ChangePasswordDialog(l10n: l10n),
    );

    if (payload == null || !context.mounted) return;

    final oldPassword = payload.oldPassword;
    final newPassword = payload.newPassword;
      final error = await ref
          .read(authNotifierProvider.notifier)
          .changePassword(oldPassword: oldPassword, newPassword: newPassword);

      if (!context.mounted) return;

      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.passwordChanged),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // По архитектуре смена пароля инвалидирует все сессии — выходим из аккаунта.
        await ref.read(authNotifierProvider.notifier).logout();
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomePage()),
          (route) => false,
        );
        return;
      }

      final normalizedError = switch (error) {
        'PASSWORD_IS_INCORRECT' => l10n.wrongCurrentPassword,
        'PASSWORDS_IS_DUPLICATE' => l10n.passwordDuplicate,
        _ => error,
      };

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(normalizedError),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
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
        // Закрываем BottomSheet, ждём конца анимации, затем меняем язык.
        _applyAfterSheetClose(context, () => localeProvider.setLocale(locale));
      },
    );
  }

  Widget _themeTile({
    required BuildContext context,
    required String label,
    required ThemeMode mode,
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
        // Аналогично языку: сначала закрываем sheet, потом переключаем тему.
        _applyAfterSheetClose(context, () => themeProvider.setThemeMode(mode));
      },
    );
  }

  void _applyAfterSheetClose(BuildContext context, VoidCallback action) {
    Navigator.pop(context);
    Future.delayed(_uiSwitchDelay, action);
  }
}

class _ChangePasswordPayload {
  final String oldPassword;
  final String newPassword;

  const _ChangePasswordPayload({
    required this.oldPassword,
    required this.newPassword,
  });
}

class _ChangePasswordDialog extends StatefulWidget {
  final AppLocalizations l10n;

  const _ChangePasswordDialog({required this.l10n});

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _localError;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = widget.l10n;

    return AlertDialog(
      title: Text(l10n.changePassword),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: _obscureOld,
              decoration: InputDecoration(
                hintText: l10n.currentPassword,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscureOld = !_obscureOld);
                  },
                  icon: Icon(
                    _obscureOld
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                hintText: l10n.newPassword,
                prefixIcon: const Icon(Icons.lock_reset_rounded),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscureNew = !_obscureNew);
                  },
                  icon: Icon(
                    _obscureNew
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              decoration: InputDecoration(
                hintText: l10n.confirmNewPassword,
                prefixIcon: const Icon(Icons.verified_user_outlined),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                  icon: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            if (_localError != null) ...[
              const SizedBox(height: 12),
              Text(
                _localError!,
                style: TextStyle(color: colorScheme.error),
              ),
            ],
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: colorScheme.surface,
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: () {
              final oldPassword = _oldPasswordController.text.trim();
              final newPassword = _newPasswordController.text.trim();
              final confirmPassword = _confirmPasswordController.text.trim();

              if (oldPassword.isEmpty ||
                  newPassword.isEmpty ||
                  confirmPassword.isEmpty) {
                setState(() => _localError = l10n.fillAllFields);
                return;
              }
              if (newPassword.length < 8) {
                setState(() => _localError = l10n.passwordTooShort);
                return;
              }
              if (!InputValidators.isAsciiPassword(oldPassword) ||
                  !InputValidators.isAsciiPassword(newPassword)) {
                setState(() => _localError = l10n.passwordInvalidChars);
                return;
              }
              if (newPassword != confirmPassword) {
                setState(() => _localError = l10n.passwordsDoNotMatch);
                return;
              }

              Navigator.pop(
                context,
                _ChangePasswordPayload(
                  oldPassword: oldPassword,
                  newPassword: newPassword,
                ),
              );
            },
            child: Text(l10n.confirm),
          ),
        ),
      ],
    );
  }
}
