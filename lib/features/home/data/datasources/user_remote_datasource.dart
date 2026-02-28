/// 1) Общее назначение:
///    DataSource для API-запросов, связанных с пользователем (просмотр и редактирование профиля).
/// 2) С какими файлами связан:
///    - `api_constants.dart` (URL эндпоинтов).
///    - Модели: `UserModel`, `UpdateRequest`.
///    - Используется в `user_provider.dart`.
/// 3) Описание функций:
///    - `getUserById(id)`: выполняет GET запрос к `/users/{id}`.
///    - `updateUser(request)`: выполняет PATCH запрос к `/users/update_info`, отправляет DTO на обновление (нужен обязательный пароль).
library;

import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/models/update_request.dart';

class UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(this._dio);

  /// GET /api/users/{id}
  Future<UserModel> getUserById(int id) async {
    final response = await _dio.get(ApiConstants.userById(id));
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// PATCH /api/users/update_info
  Future<UserModel> updateUser(UpdateRequest request) async {
    final response = await _dio.patch(
      ApiConstants.updateInfo,
      data: request.toJson(),
    );
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
