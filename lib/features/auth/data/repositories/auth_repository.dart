/// 1) Общее назначение:
///    Репозиторий авторизации, координирует удаленный источник данных (AuthRemoteDataSource) и локальное хранилище токенов.
/// 2) С какими файлами связан:
///    - `auth_remote_datasource.dart`, `token_storage.dart`.
///    - Возвращает результаты для `auth_provider.dart`.
/// 3) Описание функций:
///    - `register()` и `login()`: делегируют вызовы источнику данных, сохраняют полученные токены и юзера.
///    - Возвращают sealed class `AuthResult` (успех или отловленная ошибка `AuthFailure`).
///    - `logout()`: очищает `TokenStorage`.
///    - `isAuthenticated()`: проверяет наличие сессии.
library;

import 'package:dio/dio.dart';
import '../../../../core/storage/token_storage.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/auth_response.dart';

class AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final TokenStorage _tokenStorage;

  AuthRepository(this._dataSource, this._tokenStorage);

  /// Регистрация нового пользователя.
  /// При успехе — сохраняет токены и userId.
  Future<AuthResult> register(RegisterRequest request) async {
    try {
      final response = await _dataSource.register(request);
      await _saveAuthData(response);
      return AuthResult.success(response);
    } on DioException catch (e) {
      return AuthResult.failure(_extractErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Логин существующего пользователя.
  /// При успехе — сохраняет токены и userId.
  Future<AuthResult> login(LoginRequest request) async {
    try {
      final response = await _dataSource.login(request);
      await _saveAuthData(response);
      return AuthResult.success(response);
    } on DioException catch (e) {
      return AuthResult.failure(_extractErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('Неизвестная ошибка: $e');
    }
  }

  /// Сохраняет токены и опционально userId в secure storage.
  Future<void> _saveAuthData(AuthResponse response) async {
    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    if (response.userId != null) {
      await _tokenStorage.saveUserId(response.userId!);
    }
  }

  /// Проверяет, есть ли сохранённые токены (для авто-логина).
  Future<bool> isAuthenticated() async {
    return _tokenStorage.hasTokens();
  }

  /// Выход — сначала инвалидируем сессию на сервере, затем чистим локальные данные.
  Future<void> logout() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _dataSource.logout(refreshToken);
      }
    } catch (_) {
      // Даже если серверный logout упал, всё равно чистим локальные данные.
    } finally {
      await _tokenStorage.clearAll();
    }
  }

  /// Смена пароля текущего пользователя.
  /// Возвращает null при успехе или код/текст ошибки при неудаче.
  Future<String?> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _dataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return null;
    } on DioException catch (e) {
      return _extractChangePasswordErrorMessage(e);
    } catch (e) {
      return 'Неизвестная ошибка: $e';
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      final message = data['message'];
      if (message is List) {
        return message.join(', ');
      }
      return message?.toString() ?? 'Ошибка сервера';
    }

    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'Таймаут подключения',
      DioExceptionType.receiveTimeout => 'Сервер не отвечает',
      DioExceptionType.connectionError => 'Нет соединения с сервером',
      _ => 'Ошибка сети: ${e.message}',
    };
  }

  String _extractChangePasswordErrorMessage(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      final message = data['message']?.toString() ?? '';

      if (message.contains('PASSWORD_IS_INCORRECT')) {
        return 'PASSWORD_IS_INCORRECT';
      }
      if (message.contains('PASSWORDS_IS_DUPLICATE')) {
        return 'PASSWORDS_IS_DUPLICATE';
      }

      return message.isNotEmpty ? message : 'Ошибка сервера';
    }

    return switch (e.type) {
      DioExceptionType.connectionTimeout => 'Таймаут подключения',
      DioExceptionType.receiveTimeout => 'Сервер не отвечает',
      DioExceptionType.connectionError => 'Нет соединения с сервером',
      _ => 'Ошибка сети: ${e.message}',
    };
  }
}

/// Результат авторизации — success или failure с сообщением ошибки.
sealed class AuthResult {
  const AuthResult();

  factory AuthResult.success(AuthResponse response) = AuthSuccess;
  factory AuthResult.failure(String message) = AuthFailure;
}

class AuthSuccess extends AuthResult {
  final AuthResponse response;
  const AuthSuccess(this.response);
}

class AuthFailure extends AuthResult {
  final String message;
  const AuthFailure(this.message);
}
