/// 1) Общее назначение:
///    Безопасное хранилище JWT-токенов (access, refresh) и ID пользователя через `flutter_secure_storage`.
/// 2) С какими файлами связан:
///    - `api_client.dart` (передача токена в запросы).
///    - `auth_repository.dart` (сохранение/очистка при логине/выходе).
///    - `core_providers.dart` (предоставление хранилища в DI Riverpod).
/// 3) Описание функций:
///    - `getAccessToken`, `getRefreshToken`, `getUserId`: чтение сохраненных данных.
///    - `saveTokens`, `saveUserId`: асинхронное сохранение данных.
///    - `clearAll`: очистка хранилища (используется при логауте).
///    - `hasTokens`: проверка наличия токена.
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  Future<String?> getAccessToken() async {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<void> saveUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  Future<void> clearAll() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _userIdKey),
    ]);
  }

  Future<bool> hasTokens() async {
    final accessToken = await _storage.read(key: _accessTokenKey);
    return accessToken != null;
  }
}
