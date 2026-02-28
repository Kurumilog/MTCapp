/// 1) Общее назначение:
///    Riverpod-провайдеры и состояния (StateNotifier) для модуля авторизации.
/// 2) С какими файлами связан:
///    - `auth_repository.dart` (вызовы логики регистрации, авторизации и выхода).
///    - DI: `core_providers.dart`, `auth_remote_datasource.dart`.
///    - UI: используется в страницах `login_page.dart`, `registration_page.dart` и для редиректа в `main.dart`.
/// 3) Описание функций:
///    - `AuthState` (и наследники): описывают текущее состояние пользователя (загрузка, ошибка, авторизован, нет).
///    - `AuthNotifier`:
///      - `checkAuthStatus()` проверяет наличие токенов.
///      - `login()` и `register()` выполняют запросы к репозиторию и меняют state.
///      - `logout()` очищает токены.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/models/login_request.dart';
import '../../data/models/register_request.dart';
import '../../../../core/providers/core_providers.dart';

/// Провайдер для AuthRemoteDataSource.
final authDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient.dio);
});

/// Провайдер для AuthRepository.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepository(dataSource, tokenStorage);
});

/// Состояние авторизации.
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Notifier для управления состоянием авторизации.
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial());

  /// Проверяет, залогинен ли пользователь (есть ли сохранённые токены).
  Future<void> checkAuthStatus() async {
    final isAuth = await _repository.isAuthenticated();
    state = isAuth ? const AuthAuthenticated() : const AuthUnauthenticated();
  }

  /// Логин по username + password.
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = const AuthLoading();

    final result = await _repository.login(
      LoginRequest(username: username, password: password),
    );

    return switch (result) {
      AuthSuccess() => () {
        state = const AuthAuthenticated();
        return true;
      }(),
      AuthFailure(:final message) => () {
        state = AuthError(message);
        return false;
      }(),
    };
  }

  /// Регистрация нового пользователя.
  Future<bool> register({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
    String? surName,
    required String phoneNumber,
  }) async {
    state = const AuthLoading();

    final result = await _repository.register(
      RegisterRequest(
        username: username,
        password: password,
        email: email,
        firstName: firstName,
        lastName: lastName,
        surName: surName,
        phoneNumber: phoneNumber,
      ),
    );

    return switch (result) {
      AuthSuccess() => () {
        state = const AuthAuthenticated();
        return true;
      }(),
      AuthFailure(:final message) => () {
        state = AuthError(message);
        return false;
      }(),
    };
  }

  /// Выход из аккаунта.
  Future<void> logout() async {
    await _repository.logout();
    state = const AuthUnauthenticated();
  }
}

/// Провайдер для AuthNotifier.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});
