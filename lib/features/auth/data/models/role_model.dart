/// Модель роли пользователя.
/// Бекенд возвращает роли как массив объектов: [{"id":1,"role":"admin","description":null}].
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

@freezed
abstract class RoleModel with _$RoleModel {
  const factory RoleModel({
    required int id,
    required String role,
    String? description,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
}
