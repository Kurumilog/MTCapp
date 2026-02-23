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

## Documentation

- [x] Add Russian documentation blocks to all core files

## Verification & Deployment

- [/] Wait for Android SDK 34 installation and Gradle build
- [ ] Verify functionality on device (SM S916B)
