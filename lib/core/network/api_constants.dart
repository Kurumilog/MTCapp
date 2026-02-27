/// API-константы для взаимодействия с бекендом MTC.
/// Base URL: https://kurumi.software/api
library;

class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://kurumi.software/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refresh = '/auth/refresh';

  // Users endpoints
  static const String users = '/users';
  static String userById(int id) => '/users/$id';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
