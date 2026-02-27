/// Репозиторий авторизации — координирует datasource и token storage.
/// Единственная точка входа для auth-логики из presentation-слоя.
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

  /// Выход — удаляет все токены.
  Future<void> logout() async {
    await _tokenStorage.clearAll();
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
