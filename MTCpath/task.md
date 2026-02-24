# Task Checklist — Navbar Redesign, Localization & Features

## Navbar Redesign & UI

- [x] Rewrite `home_page.dart` — 5 tabs: Любимое, Галерея, +, Коллекции, Ещё
- [x] Create `favorites_page.dart` (stub page)
- [x] Create `more_page.dart` (renamed menu items: Отправить по ссылке, Корпоративное облако)
- [x] Remove/refactor `profile_page.dart`
- [x] Implement real actions for "+" button (camera, gallery, files)
- [x] Ensure full responsiveness (MediaQuery-based scaling)

## Localization

- [x] Add `flutter_localizations` dependency
- [x] Create localization files (RU + EN)
- [x] Integrate localization into `main.dart`
- [x] Match terminology (e.g., "Любимое" instead of "Избранное")

## Documentation & Cleanup

- [x] Add Russian documentation blocks to all core files
- [x] Export docs to `/MTCpath`
- [x] Update `README.md` with technical details, setup guide, and iOS instructions
- [x] PROJECT CLEANUP: Remove `cupertino_native` and rebranding "Glass" -> "Auth"
- [x] Create `project_context.md` for AI hand-off

## Verification & Deployment

- [x] Add iOS permissions (camera, library, mic) to `Info.plist`
- [x] Sync changes with GitHub (resolved rebase conflicts)
- [x] Verify functionality on device (SM S916B)

---

## Phase 2 — Backend Integration / Интеграция с бэкендом `[PENDING — ЖДУТ SWAGGER]`

> ⛔ **НЕ ТРОГАТЬ** до получения Swagger-документации бэкенда. API-контракты будут уточнены после его предоставления.
>
> Контекст: Flutter-приложение — мобильный клиент IaaS-платформы (NestJS + Proxmox + PBS/Ceph).

### Services
- [ ] Добавить `dio`, `crypto`, `flutter_secure_storage` в `pubspec.yaml`
- [ ] Создать `lib/core/services/auth_service.dart` (JWT login/register/refresh)
- [ ] Создать `lib/core/services/file_service.dart` (upload flow с SHA-256)
- [ ] Создать `lib/core/services/vps_service.dart` (CRUD VPS через Proxmox API)

### Auth
- [ ] Подключить реальный логин/регистрацию к `AuthService`
- [ ] Сохранять JWT в `flutter_secure_storage`
- [ ] Добавить refresh-токен логику

### File Management
- [ ] Реализовать upload с SHA-256 верификацией (4 шага, см. `project_context.md`)
- [ ] Подключить Галерею к реальному API (`GET /api/files`)
- [ ] Реализовать download + preview файлов
- [ ] Реализовать удаление файлов (`DELETE /api/files/:id`)
- [ ] Наполнить разделы «Любимое» и «Коллекции» данными

### VPS Manager
- [ ] Создать `lib/features/home/presentation/pages/vps_page.dart`
- [ ] Конфигуратор: vCPU / RAM / диск / VLAN-тег
- [ ] Список запущенных VPS с мониторингом (CPU/RAM/диск > 80% — alert)
- [ ] Действия: создать / удалить VPS

### Billing
- [ ] Создать `lib/features/home/presentation/pages/billing_page.dart`
- [ ] Отображать тарифы: vCPU 16 BYN, RAM 17 BYN, диск 0.95 BYN
- [ ] Показывать текущее потребление ресурсов пользователя
