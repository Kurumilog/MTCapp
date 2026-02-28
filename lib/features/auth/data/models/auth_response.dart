/// 1) Общее назначение:
///    Модель ответа от бекенда при успешной авторизации или обновлении токена.
/// 2) С какими файлами связан:
///    - `auth_remote_datasource.dart` (парсинг ответа).
///    - `auth_repository.dart` (использование данных для сохранения токенов).
/// 3) Описание функций:
///    - `accessToken`, `refreshToken`: JWT токены, получаемые из заголовков.
///    - `userId`: ID залогиненного пользователя (приходит в теле ответа, null при refresh-запросе).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_response.freezed.dart';

@freezed
abstract class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,

    /// ID пользователя из тела ответа. null при refresh.
    int? userId,
  }) = _AuthResponse;
}
