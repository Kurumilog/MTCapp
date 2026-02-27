/// Модель пользователя (данные из ответа бекенда GET /users/{id}).
/// Роли приходят как массив объектов: [{"id":1,"role":"admin","description":null}].
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
