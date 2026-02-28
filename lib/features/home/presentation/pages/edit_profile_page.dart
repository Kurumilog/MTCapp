/// 1) Общее назначение:
///    Экран изменения личных данных пользователя (профиля).
/// 2) С какими файлами связан:
///    - `user_provider.dart` (загрузка начальных данных и отправка обновления).
///    - `auth_text_field.dart`, `auth_button.dart` (UI компоненты).
///    - Модели `UpdateRequest`, `UserModel`.
/// 3) Описание функций:
///    - Отрисовывает форму (TextEditingController) с текущими данными (поле username заблокировано).
///    - `_hasChanges`: проверяет, менялись ли данные относительно исходных.
///    - `_handleSave()`: запрашивает подтверждение пароля в диалоге,
///      затем отправляет `UpdateRequest`. Обрабатывает ошибки без краша UI.
library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../auth/data/models/update_request.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../auth/presentation/widgets/auth_button.dart';
import '../providers/user_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _surNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Исходные значения для отслеживания изменений
  String _origFirstName = '';
  String _origLastName = '';
  String _origSurName = '';
  String _origEmail = '';
  String _origPhone = '';

  bool _initialized = false;
  bool _saving = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _surNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Проверяет, были ли реально изменены данные относительно исходных.
  bool get _hasChanges {
    return _firstNameController.text != _origFirstName ||
        _lastNameController.text != _origLastName ||
        _surNameController.text != _origSurName ||
        _emailController.text != _origEmail ||
        _phoneController.text != _origPhone;
  }

  /// Обновляет исходные значения (после успешного сохранения).
  void _syncOriginals() {
    _origFirstName = _firstNameController.text;
    _origLastName = _lastNameController.text;
    _origSurName = _surNameController.text;
    _origEmail = _emailController.text;
    _origPhone = _phoneController.text;
  }

  /// Показывает диалог для ввода пароля и выполняет обновление профиля.
  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    if (!_hasChanges) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.noChanges),
          backgroundColor: colorScheme.secondary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Показываем диалог ввода пароля
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PasswordConfirmDialog(l10n: l10n),
    );

    // Пользователь нажал «Отмена»
    if (password == null || password.isEmpty) return;
    if (!mounted) return;

    setState(() => _saving = true);

    try {
      final request = UpdateRequest(
        password: password,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        surName: _surNameController.text.isEmpty
            ? null
            : _surNameController.text,
        phoneNumber:
            _phoneController.text.isEmpty ? null : _phoneController.text,
      );

      final dataSource = ref.read(userDataSourceProvider);
      await dataSource.updateUser(request);

      // Инвалидируем провайдер, чтобы данные обновились на всех экранах
      ref.invalidate(userProvider);

      // Обновляем исходные значения, чтобы кнопка снова стала неактивной
      _syncOriginals();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.profileUpdated),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } on DioException catch (e) {
      if (!mounted) return;
      final statusCode = e.response?.statusCode;
      final message = (statusCode == 401 || statusCode == 403)
          ? l10n.wrongPassword
          : '${l10n.updateError}: ${e.response?.statusMessage ?? e.message}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.updateError}: $e'),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final userAsync = ref.watch(userProvider);

    // Заполняем контроллеры один раз, когда данные загрузились
    if (!_initialized) {
      userAsync.whenData((user) {
        if (user != null) {
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _surNameController.text = user.surName ?? '';
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber ?? '';
          _syncOriginals();
          _initialized = true;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Username — read-only, нельзя изменить
            userAsync.maybeWhen(
              data: (user) {
                if (user == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: user.username),
                    decoration: InputDecoration(
                      hintText: l10n.username,
                      prefixIcon: const Icon(Icons.alternate_email_rounded),
                      suffixIcon: Tooltip(
                        message: l10n.usernameCannotChange,
                        child: const Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            AuthTextField(
              hintText: l10n.firstName,
              icon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              controller: _firstNameController,
            ),
            AuthTextField(
              hintText: l10n.lastName,
              icon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              controller: _lastNameController,
            ),
            AuthTextField(
              hintText: l10n.surName,
              icon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              controller: _surNameController,
            ),
            AuthTextField(
              hintText: l10n.email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            AuthTextField(
              hintText: l10n.phoneNumber,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              controller: _phoneController,
            ),
            const SizedBox(height: 16),
            AuthButton(
              text: _saving ? '...' : l10n.saveChanges,
              onPressed: _saving ? null : _handleSave,
            ),
          ],
        ),
      ),
    );
  }
}

/// Диалог подтверждения пароля перед сохранением.
class _PasswordConfirmDialog extends StatefulWidget {
  final AppLocalizations l10n;

  const _PasswordConfirmDialog({required this.l10n});

  @override
  State<_PasswordConfirmDialog> createState() => _PasswordConfirmDialogState();
}

class _PasswordConfirmDialogState extends State<_PasswordConfirmDialog> {
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.l10n.password),
      content: TextField(
        controller: _passwordController,
        autofocus: true,
        obscureText: _obscure,
        decoration: InputDecoration(
          hintText: widget.l10n.enterCurrentPassword,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(_obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onPressed: () => setState(() => _obscure = !_obscure),
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) Navigator.pop(context, value);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final pwd = _passwordController.text;
            if (pwd.isNotEmpty) Navigator.pop(context, pwd);
          },
          child: Text(widget.l10n.confirm),
        ),
      ],
    );
  }
}
