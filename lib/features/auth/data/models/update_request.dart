/// 1) Общее назначение:
///    Модель DTO запроса на обновление профиля пользователя.
/// 2) С какими файлами связан:
///    - `user_remote_datasource.dart` (передача данных в PUT /api/users).
///    - `edit_profile_page.dart` (сбор данных с формы).
/// 3) Описание функций:
///    - Обязательно требует `password` (для подтверждения).
///    - Остальные поля (email, firstName, lastName, surName, phoneNumber) опциональны.
library;

import "package:freezed_annotation/freezed_annotation.dart";

part "update_request.freezed.dart";
part "update_request.g.dart";

@freezed
abstract class UpdateRequest with _$UpdateRequest {
  const factory UpdateRequest({
    /// Текущий пароль — обязательное поле для подтверждения изменений.
    required String password,

    /// Новый email (необязательно).
    String? email,

    /// Новое имя (необязательно).
    String? firstName,

    /// Новая фамилия (необязательно).
    String? lastName,

    /// Новое отчество (необязательно).
    String? surName,

    /// Номер телефона (необязательно).
    String? phoneNumber,
  }) = _UpdateRequest;

  factory UpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateRequestFromJson(json);
}
