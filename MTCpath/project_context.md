# Project Context & AI Hand-off Summary / Контекст проекта для ИИ

## Big Picture / Контекст большого проекта

> ⚠️ **ВАЖНО**: MTCapp — это только **мобильный клиент** в составе более крупного проекта.

Полный проект — **MVP IaaS-платформы** (аналог MTS Cloud) для хакатона «Space Hackathon with MTC» (BSU + MTS Беларусь, 4–6 марта 2026, 48 часов).

Архитектура всей платформы:
```
[Flutter App / Web (React+Vite)]  ←→  [NestJS Backend API]
                                              ↓
                              [Proxmox VE + SDN (VLAN/VXLAN)]
                              [PBS / Ceph (S3) — file storage]
                              [Postgres — metadata & billing]
                              [OpenStack — optional orchestrator]
```

Что делает каждая часть:
- **Flutter App** (этот репозиторий): мобильный клиент (Android/iOS) — auth, просмотр файлов, загрузка медиа.
- **NestJS Backend**: REST/gRPC API, JWT+RBAC, интеграция с Proxmox и хранилищем.
- **Proxmox + SDN**: виртуализация VPS/VDS, сетевая изоляция через VLAN/VXLAN.
- **PBS / Ceph RGW**: хранение файлов с верификацией SHA-256, presigned S3 URLs.
- **Postgres**: метаданные файлов/VPS/пользователей, биллинг (цены MTS: vCPU 16 BYN, RAM 17 BYN, диск 0.95 BYN).

---

## Overview / Обзор

**MTCapp** — мобильный клиент (Flutter) облачной IaaS-платформы MTC Cloud. Это приватное приложение для управления личным/корпоративным облаком: просмотр файлов, загрузка медиа, (в будущем) управление VPS.

Основные фичи: адаптивный дизайн, мультиязычность (RU/EN), работа с медиа (камера, галерея, файлы).

## Technical Stack / Технический стек

- **Framework**: Flutter (Targeting Android API 34+ and iOS).
- **Architecture**: Core/Features layered architecture.
- **State Management**: `ChangeNotifier` (via `LocaleProvider` for runtime localization).
- **Styling**: Custom Theme (`Nunito` font), no external UI kits (removed `cupertino_native`/`liquid_glass`).
- **Media**: `image_picker`, `file_picker`.

## Key Implementation Details / Ключевые детали реализации

### 1. Rebranding & UI

- All "Glass" or "Liquid Glass" components have been removed or rebranded to **Auth** components (e.g., `AuthButton`, `AuthTextField`, `AuthBackground`).
- The UI is purely Flutter Material based, utilizing `Container`, `BackdropFilter`, and standard widgets for a modern look without buggy external dependencies.

Все "стеклянные" компоненты были удалены или переименованы в **Auth**. Интерфейс построен на стандартных виджетах Flutter (`ElevatedButton`, `BackdropFilter`) для стабильности.

### 2. Localization System

- Managed by `LocaleProvider` and `AppLocalizations`.
- Supports runtime switching between Russian (RU) and English (EN).
- Settings page is accessible via the **"More" (Ещё)** tab.

Система локализации поддерживает переключение RU/EN на лету через `LocaleProvider`. Настройки — во вкладке "Ещё".

### 3. Critical Fixes / Критические исправления

- **Navigator Context Safety**: To prevent crashes when returning from the camera/picker on newer Android versions, the `Navigator` instance is extracted _before_ the `await` call. See `lib/features/home/presentation/pages/home_page.dart`.
- **iOS Permissions**: `Info.plist` is configured with `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`, and `NSMicrophoneUsageDescription`.

Исправлен потенциальный краш при работе с камерой (Navigator извлекается заранее). В `Info.plist` добавлены все разрешения для iOS.

## Project Structure / Структура проекта

- `lib/core/`: Theme, L10n, and global widgets (`AuthBackground`).
- `lib/features/auth/`: Login, Registration, and Welcome screens.
- `lib/features/home/`: Main shell with 5-tab navigation.
- `MTCpath/`: Dev history and this context file.

## Backend Integration / Интеграция с бэкендом `[PENDING — ЖДУТ SWAGGER]`

> ⛔ **НЕ РЕАЛИЗОВЫВАТЬ** до получения Swagger-документации бэкенда.
> Данный раздел содержит предварительные предположения об API — будут уточнены по Swagger.

Flutter-приложение должно взаимодействовать с NestJS API. Ключевэе детали для разработчика:

### Auth Flow
- Логин/регистрация → NestJS возвращает **JWT-токен**.
- Роли (RBAC): `client` | `admin` | `corporate`. Хранить токен в `flutter_secure_storage`.

### File Upload Flow (строгий порядок!)
1. Клиент вычисляет **SHA-256** файла локально (`crypto` пакет).
2. `POST /api/files/upload-request` — передаёт имя, размер, хэш → получает **signed URL** (от PBS/Ceph RGW).
3. Прямой `PUT` на signed URL с заголовком `X-File-Hash: <sha256>`.
4. `POST /api/files/complete` — бэкенд верифицирует хэш в хранилище и сохраняет в Postgres.

> Если хэши не совпадают — бэкенд удаляет файл. Не пропускать шаги!

### Key API Endpoints (NestJS)
```
POST   /auth/login
POST   /auth/register
GET    /api/files              — список файлов пользователя
POST   /api/files/upload-request
POST   /api/files/complete
DELETE /api/files/:id
GET    /api/vps                — список VPS/VDS пользователя
POST   /api/vps/create         — создать VM (CPU/RAM/диск/сеть)
DELETE /api/vps/:id
GET    /api/billing/usage
```

### Packages to Add for Integration
- `dio` — HTTP-клиент с interceptors (JWT-токен в headers).
- `crypto` — SHA-256 вычисление перед загрузкой.
- `flutter_secure_storage` — безопасное хранение JWT.

## Future Screens / Будущие экраны

| Экран | Вкладка | Статус |
|---|---|---|
| Список файлов | Галерея | stub → нужна интеграция с API |
| Избранное/Коллекции | Любимое, Коллекции | stub → логика + API |
| VPS Manager | Ещё | не создан |
| Биллинг | Ещё | не создан |
| Корпоративное облако (shared folders) | Ещё | stub |

VPS Manager: конфигуратор (выбор vCPU / RAM / диск / VLAN-тег) → `POST /api/vps/create`.

## Next Steps / Что делать дальше

1. Добавить `dio`, `crypto`, `flutter_secure_storage` в `pubspec.yaml`.
2. Реализовать `AuthService` (JWT, сохранение токена, refresh).
3. Реализовать `FileService` с полным upload-flow (SHA-256 → signed URL → PUT → complete).
4. Подключить реальные данные к экранам «Галерея» и «Коллекции».
5. Создать экран VPS Manager (конфигуратор + список).
6. Добавить экран Биллинга (цены: vCPU 16 BYN, RAM 17 BYN, диск 0.95 BYN).
