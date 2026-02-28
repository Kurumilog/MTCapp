/// 1) Общее назначение:
///    Модель DTO для запроса на вход (логин).
/// 2) С какими файлами связан:
///    - `auth_remote_datasource.dart` (передача данных в POST /auth/login).
///    - Связан со сгенерированным кодом freezed/json_serializable.
/// 3) Описание функций:
///    - Содержит обязательные поля username и password.
///    - `toJson()`: преобразует объект в JSON для Dio.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String username,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
