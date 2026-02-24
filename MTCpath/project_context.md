# Project Context & AI Hand-off Summary / Контекст проекта для ИИ

## Overview / Обзор

**MTCapp** is a private Flutter-based cloud storage visualization app. It features a responsive design, multi-language support (RU/EN), and integrated mobile features (Camera, Gallery, File Picker).

Это приватное Flutter-приложение для визуализации облачного хранилища MTC Cloud. Основные фичи: адаптивный дизайн, мультиязычность (RU/EN) и работа с медиа (камера, галерея, файлы).

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

## Next Steps / Что делать дальше

- Implement actual file upload/download logic (currently stubs).
- Develop the "Collections" and "Favorites" screen logic.
- Integrate with real backend APIs.

Реализовать логику загрузки файлов, доработать разделы "Коллекции" и "Любимое", подключить API.
