/// Riverpod-провайдеры для core-зависимостей:
/// TokenStorage, ApiClient, Dio.
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
