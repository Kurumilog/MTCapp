/// 1) Общее назначение:
///    Модель бизнес-логики роли пользователя (содержит данные роли).
/// 2) С какими файлами связан:
///    - `user_model.dart` (массив ролей привязан к пользователю).
/// 3) Описание функций:
///    - Описывает сущность роли: id, название и описание.
///    - Сериализуется и десериализуется с помощью freezed/json_serializable.
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
