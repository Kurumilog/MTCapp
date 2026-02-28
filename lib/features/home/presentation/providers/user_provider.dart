/// 1) Общее назначение:
///    Riverpod-провайдеры для управления состоянием данных профиля пользователя.
/// 2) С какими файлами связан:
///    - `user_remote_datasource.dart` (выполнение запросов к API).
///    - `auth_provider.dart` и `token_storage.dart` (отслеживание состояния сессии пользователя).
///    - Используется в `settings_page.dart`, `edit_profile_page.dart` для отображения данных.
/// 3) Описание функций:
///    - `userDataSourceProvider`: предоставляет DataSource.
///    - `userProvider`: FutureProvider загружающий пользователя по ID из `TokenStorage`.
///       Сбрасывается/перезапрашивается при изменениях `authNotifierProvider`.
///    - `updateProfileProvider`: возвращает функцию для выполнения запроса на изменение профиля и отлова ошибок.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/models/update_request.dart';
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

/// Провайдер для обновления профиля пользователя.
/// Возвращает обновлённую модель при успехе, бросает исключение при ошибке.
final updateProfileProvider =
    FutureProvider.family<UserModel, UpdateRequest>((ref, request) async {
  final dataSource = ref.watch(userDataSourceProvider);
  final updatedUser = await dataSource.updateUser(request);
  // Инвалидируем кеш текущего пользователя, чтобы данные обновились.
  ref.invalidate(userProvider);
  return updatedUser;
});
