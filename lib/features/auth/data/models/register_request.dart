/// 1) Общее назначение:
///    Модель DTO (Data Transfer Object) для создания запроса на регистрацию нового пользователя.
/// 2) С какими файлами связан:
///    - `auth_remote_datasource.dart` (передача данных в POST /auth/register).
///    - Напрямую связан со сгенерированным кодом freezed/json_serializable.
/// 3) Описание функций:
///    - Содержит поля username, password, email, firstName, lastName, surName (опционально) и phoneNumber.
///    - `toJson()` и `fromJson()` генерируются автоматически.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.freezed.dart';
part 'register_request.g.dart';

@freezed
abstract class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
    String? surName,
    required String phoneNumber,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}
