/// Экран редактирования личных данных пользователя (stub).
/// Username изменить нельзя. Кнопка «Сохранить» — заглушка.
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
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
  bool _initialized = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _surNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final userAsync = ref.watch(userProvider);

    // Заполняем поля один раз когда данные загрузились
    if (!_initialized) {
      userAsync.whenData((user) {
        if (user != null) {
          _firstNameController.text = user.firstName;
          _lastNameController.text = user.lastName;
          _surNameController.text = user.surName ?? '';
          _emailController.text = user.email;
          _phoneController.text = user.phoneNumber ?? '';
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
              text: l10n.saveChanges,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.comingSoonFeature),
                    backgroundColor: colorScheme.secondary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
