/// 1) Общее назначение:
///    API-константы для взаимодействия с бекендом MTC (Base URL, эндпоинты, таймауты).
/// 2) С какими файлами связан:
///    - Связан с `api_client.dart` (настройка Dio), `auth_remote_datasource.dart`, `user_remote_datasource.dart`.
/// 3) Описание функций:
///    - Хранит URL константы: register, login, refresh, users. Класс не предназначен для инстанцирования.
library;

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://kurumi.software/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';
  static const String changePassword = '/auth/change_password';
  static const String logout = '/auth/logout';
  static const String logoutAll = '/auth/logout_all';

  // Users endpoints
  static const String users = '/users';
  static const String updateInfo = '/users/update_info';
  static String userById(int id) => '/users/$id';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
