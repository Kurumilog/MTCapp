/// 1) Общее назначение:
///    Экран регистрации нового пользователя (Material 3).
///    Подключён к Riverpod AuthNotifier для реальной регистрации.
/// 2) С какими файлами связан:
///    - lib/features/auth/presentation/widgets/auth_text_field.dart
///    - lib/features/auth/presentation/widgets/auth_button.dart
///    - lib/features/auth/presentation/providers/auth_provider.dart
/// 3) Описание функций:
///    - build(): Логотип, M3 Card с полями регистрации и кнопкой.
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final l10n = AppLocalizations.of(context);
    final username = _usernameController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _showError(l10n.fillAllFields);
      return;
    }

    if (password.length < 8) {
      _showError(l10n.passwordTooShort);
      return;
    }

    if (password != confirmPassword) {
      _showError(l10n.passwordsDoNotMatch);
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).register(
          username: username,
          password: password,
          email: email,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phone,
        );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    // Слушаем состояние и показываем ошибку от сервера
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthError) {
        _showError(next.message);
      }
    });

    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_rounded, color: colorScheme.primary, size: 36),
                  const SizedBox(width: 10),
                  Text(
                    'MTC Cloud',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Auth Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 28.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.registerTitle,
                        style: textTheme.headlineSmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      AuthTextField(
                        hintText: l10n.username,
                        icon: Icons.alternate_email_rounded,
                        controller: _usernameController,
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
                        hintText: l10n.phoneNumber,
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      ),
                      AuthTextField(
                        hintText: l10n.email,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      AuthTextField(
                        hintText: l10n.password,
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      AuthTextField(
                        hintText: l10n.confirmPassword,
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                      const SizedBox(height: 8),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AuthButton(
                              text: l10n.registerAction,
                              onPressed: _handleRegister,
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Login prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.hasAccountPrompt,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(l10n.loginAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
