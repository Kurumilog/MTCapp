/// Datasource для получения данных пользователя.
/// Требует Authorization: Bearer accessToken (добавляется интерсептором).
library;

import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../auth/data/models/user_model.dart';

class UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSource(this._dio);

  /// GET /api/users/{id}
  Future<UserModel> getUserById(int id) async {
    final response = await _dio.get(ApiConstants.userById(id));
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }
}
