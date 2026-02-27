/// Настройка Dio-клиента с интерцепторами для JWT.
/// Автоматически добавляет accessToken в заголовки,
/// при 401 — пытается обновить токен через /auth/refresh.
library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_constants.dart';
import '../storage/token_storage.dart';

class ApiClient {
  late final Dio dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(_AuthInterceptor(_tokenStorage, dio));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }
}

class _AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;

  _AuthInterceptor(this._tokenStorage, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Не добавляем токен на публичные эндпоинты
    final publicPaths = [
      ApiConstants.register,
      ApiConstants.login,
    ];

    final isPublic = publicPaths.any((path) => options.path.contains(path));

    if (!isPublic) {
      final accessToken = await _tokenStorage.getAccessToken();
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Попытка обновить токен
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        return handler.next(err);
      }

      try {
        final response = await _dio.post(
          ApiConstants.refresh,
          options: Options(
            headers: {'Authorization': 'Bearer $refreshToken'},
          ),
        );

        final newAccessToken = response.headers.value('access_token') ?? '';
        final newRefreshToken = response.headers.value('refresh_token') ?? '';

        await _tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        // Повторяем оригинальный запрос с новым токеном
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await _dio.fetch(retryOptions);
        return handler.resolve(retryResponse);
      } on DioException {
        // Refresh тоже упал — разлогиниваем
        await _tokenStorage.clearAll();
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}
