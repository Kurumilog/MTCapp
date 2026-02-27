/// Datasource для авторизации — работает напрямую с Dio.
/// Все HTTP-запросы к /auth/* инкапсулированы здесь.
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
  /// Токены приходят в заголовках: access_token, refresh_token.
  /// Тело содержит данные пользователя (включая id).
  Future<AuthResponse> register(RegisterRequest request) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: request.toJson(),
    );
    return _parseAuthResponse(response, includeUserId: true);
  }

  /// POST /auth/login
  /// Токены приходят в заголовках: access_token, refresh_token.
  /// Тело содержит данные пользователя (включая id).
  Future<AuthResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: request.toJson(),
    );
    return _parseAuthResponse(response, includeUserId: true);
  }

  /// POST /auth/refresh
  /// refresh_token передаётся в заголовке Authorization: Bearer {token}.
  /// Новые токены также возвращаются в заголовках ответа.
  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.refresh,
      options: Options(
        headers: {'Authorization': 'Bearer $refreshToken'},
      ),
    );
    return _parseAuthResponse(response, includeUserId: false);
  }

  /// Парсит токены из заголовков ответа и опционально userId из тела.
  AuthResponse _parseAuthResponse(
    Response<dynamic> response, {
    required bool includeUserId,
  }) {
    final accessToken = response.headers.value('access_token') ?? '';
    final refreshToken = response.headers.value('refresh_token') ?? '';

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
}
