/// 1) Общее назначение:
///    Глобальная настройка HTTP-клиента Dio с интерцепторами для JWT и обработки 401 Unauthorized.
/// 2) С какими файлами связан:
///    - Использует `api_constants.dart` (для url/timeout).
///    - Использует `token_storage.dart` (для чтения/сохранения токенов).
///    - Зависимость инжектится во все модули `*_remote_datasource.dart`.
/// 3) Описание функций:
///    - `ApiClient`: инициализирует `Dio` и добавляет логгер (в debug) и `_AuthInterceptor`.
///    - `_AuthInterceptor.onRequest`: добавляет `Authorization: Bearer <token>` в заголовок.
///    - `_AuthInterceptor.onError`: ловит 401 и обновляет токены через `/auth/refresh`, затем повторяет исходный запрос.
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
    final publicPaths = [ApiConstants.register, ApiConstants.login];

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
            headers: {'Cookie': 'refresh_token=$refreshToken'},
          ),
        );

        final newAccessToken = response.headers.value('access_token') ?? '';
        final newRefreshToken = _extractRefreshToken(response) ?? '';

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

  /// Извлекает refresh_token из Set-Cookie заголовка.
  String? _extractRefreshToken(Response<dynamic> response) {
    final cookies = response.headers['set-cookie'];
    if (cookies != null) {
      for (final cookie in cookies) {
        if (cookie.startsWith('refresh_token=')) {
          return cookie.split(';').first.substring('refresh_token='.length);
        }
      }
    }
    // Фоллбек: кастомный заголовок
    return response.headers.value('refresh_token');
  }
}
