/// Модель ответа от бекенда при логине/регистрации.
/// Токены приходят в заголовках ответа (access_token, refresh_token).
/// userId приходит в теле ответа (только для login/register).
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
