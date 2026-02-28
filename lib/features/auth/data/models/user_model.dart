/// 1) Общее назначение:
///    Модель бизнес-логики пользователя (содержит данные профиля).
/// 2) С какими файлами связан:
///    - `user_remote_datasource.dart` (получение данных из `/users/{id}`).
///    - `edit_profile_page.dart` (отображение данных в полях ввода).
/// 3) Описание функций:
///    - Описывает сущность пользователя: id, username, email, имена и телефон.
///    - Сериализуется и десериализуется с помощью freezed/json_serializable.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'role_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String username,
    required String email,
    required String firstName,
    required String lastName,
    String? surName,
    String? phoneNumber,
    List<RoleModel>? roles,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
