/// Riverpod-провайдер для данных текущего пользователя.
/// Читает userId из TokenStorage и загружает профиль через GET /users/{id}.
/// Автоматически обновляется при смене состояния авторизации.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/user_remote_datasource.dart';

/// Провайдер для UserRemoteDataSource.
final userDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserRemoteDataSource(apiClient.dio);
});

/// Провайдер данных текущего пользователя.
/// Возвращает null если userId не сохранён (пользователь нажал «Пропустить»).
/// Пересоздаётся автоматически при изменении authNotifierProvider (логин / выход).
final userProvider = FutureProvider<UserModel?>((ref) async {
  // Следим за состоянием авторизации — при логине / выходе провайдер
  // автоматически инвалидируется и перезапрашивает данные.
  final authState = ref.watch(authNotifierProvider);
  if (authState is AuthUnauthenticated) return null;

  final TokenStorage tokenStorage = ref.watch(tokenStorageProvider);
  final dataSource = ref.watch(userDataSourceProvider);

  final userId = await tokenStorage.getUserId();
  if (userId == null) return null;

  return dataSource.getUserById(userId);
});
