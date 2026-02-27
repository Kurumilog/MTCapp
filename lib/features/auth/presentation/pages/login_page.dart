/// 1) Общее назначение:
///    Экран входа (Login) для существующих пользователей (Material 3).
///    Подключён к Riverpod AuthNotifier для реальной авторизации.
/// 2) С какими файлами связан:
///    - lib/features/auth/presentation/widgets/auth_text_field.dart
///    - lib/features/auth/presentation/widgets/auth_button.dart
///    - lib/features/auth/presentation/providers/auth_provider.dart
/// 3) Описание функций:
///    - build(): Логотип, M3 Card с полями username + password, кнопка входа.
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../providers/auth_provider.dart';
import 'registration_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  /// Если true — после успешного входа делаем pop (вызов из MorePage).
  /// Если false — pushReplacement на HomePage (вызов из WelcomePage).
  final bool popOnSuccess;

  const LoginPage({super.key, this.popOnSuccess = false});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showError(l10n.fillAllFields);
      return;
    }

    if (password.length < 8) {
      _showError(l10n.passwordTooShort);
      return;
    }

    final success = await ref.read(authNotifierProvider.notifier).login(
          username: username,
          password: password,
        );

    if (success && mounted) {
      if (widget.popOnSuccess) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
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
                        l10n.welcome,
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
                        hintText: l10n.password,
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 8),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : AuthButton(
                              text: l10n.loginAction,
                              onPressed: _handleLogin,
                            ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Registration prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noAccountPrompt,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegistrationPage(),
                      ),
                    ),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: Text(l10n.registerAction),
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
