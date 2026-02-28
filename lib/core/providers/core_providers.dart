/// 1) Общее назначение:
///    Глобальные Riverpod-провайдеры для core-зависимостей приложения (хранилище токенов, API-клиент).
/// 2) С какими файлами связан:
///    - Связан с `token_storage.dart` и `api_client.dart`.
///    - Используется в `auth_provider.dart` и `user_provider.dart` для внедрения зависимостей.
/// 3) Описание функций:
///    - `tokenStorageProvider`: синглтон-провайдер экземпляра `TokenStorage`.
///    - `apiClientProvider`: провайдер `ApiClient`, зависящий от `tokenStorageProvider`.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/token_storage.dart';
import '../network/api_client.dart';

/// Провайдер для TokenStorage — единственный экземпляр.
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

/// Провайдер для ApiClient — зависит от TokenStorage.
final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return ApiClient(tokenStorage);
});
