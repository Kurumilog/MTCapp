# Implementation Plan — Project Finalization & AI Hand-off

## Goal

Finish the MTCapp refactoring, clean up the codebase from buggy dependencies, and prepare a comprehensive context for the next AI developer.

## realized Changes

### 1. Refactoring & Rebranding

- **[DELETE]** `cupertino_native` dependency (unstable).
- **[RENAME]** `GlassButton` -> `AuthButton`, `GlassTextField` -> `AuthTextField`, `GlassBackground` -> `AuthBackground`.
- **[RENAME]** Files renamed to match class names (e.g., `auth_button.dart`).
- **[UPDATE]** All imports and color constants (`glassWhite` -> `translucentWhite`).

### 2. Documentation & Structure

- **[NEW]** `MTCpath/project_context.md`: Detailed "brain dump" for the next AI assistant.
- **[MODIFY]** `README.md`: Included iOS permissions, CocoaPods steps, and a technical architecture overview.
- **[MODIFY]** All source files: Added Russian/English documentation block at the top.

### 3. iOS Support

- **[MODIFY]** `ios/Runner/Info.plist`: Added `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, and `NSMicrophoneUsageDescription`.

## Hand-off Checklist

- [x] All "Glass" branding removed.
- [x] No unused dependencies in `pubspec.yaml`.
- [x] `project_context.md` contains the "Navigator Context Safety" logic explanation.
- [x] All changes pushed to GitHub.

## Verification

- Run `flutter run` on Android (SM S916B) to confirm camera/file functionality.
- Verify `README.md` instructions on a Mac environment for iOS build.
- Confirm `flutter analyze` returns no errors.

---

## Phase 2 Plan — Backend Integration / Интеграция с бэкендом `[PENDING — ЖДУТ SWAGGER]`

> ⛔ **НЕ НАЧИНАТЬ** до получения Swagger-документации бэкенда.
> Ендпоинты, параметры запросов и схемы ответов будут уточнены по Swagger до начала разработки.
>
> Фаза 1 (рефакторинг UI) завершена. Ниже — план следующей фазы.

### Контекст
Flutter-приложение является **мобильным клиентом** платформы MTC Cloud IaaS. Бэкенд — NestJS + Postgres + Proxmox. Хранилище — PBS/Ceph с presigned S3 URLs и SHA-256 верификацией.

### Задачи Phase 2

**[ADD]** Зависимости:
- `dio` — HTTP с JWT-interceptor.
- `crypto` — SHA-256 для файлов.
- `flutter_secure_storage` — хранение токена.

**[NEW]** `lib/core/services/auth_service.dart` — JWT login/register/logout, сохранение токена.

**[NEW]** `lib/core/services/file_service.dart` — Upload flow: SHA-256 → signed URL → PUT → complete.

**[NEW]** `lib/core/services/vps_service.dart` — Запросы к `/api/vps`.

**[UPDATE]** `lib/features/auth/` — Подключить `AuthService` вместо mock-логина.

**[UPDATE]** `lib/features/home/` — Галерея/Коллекции подключить к `FileService`.

**[NEW]** `lib/features/home/presentation/pages/vps_page.dart` — VPS Manager.

**[NEW]** `lib/features/home/presentation/pages/billing_page.dart` — Биллинг.

### Критический порядок загрузки файлов
```
1. SHA-256(file) локально
2. POST /api/files/upload-request → signed URL
3. PUT signedUrl (с заголовком X-File-Hash)
4. POST /api/files/complete → верификация на сервере
```
Нарушение порядка = файл не сохранится.
