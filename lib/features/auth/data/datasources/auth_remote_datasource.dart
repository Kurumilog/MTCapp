/// 1) Общее назначение:
///    DataSource для сетевых вызовов модуля авторизации с использованием пакета Dio.
/// 2) С какими файлами связан:
///    - `api_constants.dart` (эндпоинты).
///    - `auth_repository.dart` (поставщик данных для репозитория).
///    - Модели запросов: `RegisterRequest`, `LoginRequest`, `AuthResponse`.
/// 3) Описание функций:
///    - `register()`: POST /auth/register, парсит токены из заголовков ответа и ID из тела.
///    - `login()`: POST /auth/login.
///    - `refreshToken()`: POST /auth/refresh, обновляет токены.
///    - `_parseAuthResponse()`: вспомогательный метод извлечения данных из `Response`.
library;

import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/register_request.dart';
import '../models/login_request.dart';
import '../models/auth_response.dart';

class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// POST /auth/register
  /// access_token приходит в заголовке, refresh_token — как HttpOnly cookie.
  /// Тело содержит данные пользователя (включая id).
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return _parseAuthResponse(response, includeUserId: true);
  }

  /// POST /auth/login
  /// access_token приходит в заголовке, refresh_token — как HttpOnly cookie.
  /// Тело содержит данные пользователя (включая id).
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return _parseAuthResponse(response, includeUserId: true);
  }

  /// POST /auth/refresh
  /// refresh_token передаётся как cookie.
  /// Новый access_token — в заголовке, новый refresh_token — в Set-Cookie.
  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.refresh,
      options: Options(
        headers: {'Cookie': 'refresh_token=$refreshToken'},
      ),
    );
    return _parseAuthResponse(response, includeUserId: false);
  }

  /// DELETE /auth/logout
  /// Завершает текущую сессию (удаляет refresh-токен на сервере).
  Future<void> logout(String refreshToken) async {
    await _dio.delete(
      ApiConstants.logout,
      options: Options(
        headers: {'Cookie': 'refresh_token=$refreshToken'},
      ),
    );
  }

  /// POST /auth/change_password
  /// Смена пароля. Требует access-token (добавляется интерцептором).
  /// После смены все сессии пользователя аннулируются на сервере.
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _dio.post(
      ApiConstants.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  /// Парсит access_token из заголовка и refresh_token из Set-Cookie.
  AuthResponse _parseAuthResponse(
    Response<dynamic> response, {
    required bool includeUserId,
  }) {
    final accessToken = response.headers.value('access_token') ?? '';
    final refreshToken = _extractRefreshTokenFromCookies(response);

    int? userId;
    if (includeUserId && response.data is Map<String, dynamic>) {
      final body = response.data as Map<String, dynamic>;
      userId = (body['id'] as num?)?.toInt();
    }

    return AuthResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );
  }

  /// Извлекает значение refresh_token из Set-Cookie заголовка ответа.
  String _extractRefreshTokenFromCookies(Response<dynamic> response) {
    final cookies = response.headers['set-cookie'];
    if (cookies != null) {
      for (final cookie in cookies) {
        if (cookie.startsWith('refresh_token=')) {
          return cookie.split(';').first.substring('refresh_token='.length);
        }
      }
    }
    // Фоллбек: попробовать кастомный заголовок (обратная совместимость)
    return response.headers.value('refresh_token') ?? '';
  }
}
