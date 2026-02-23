# Navbar Redesign + English Localization

Redesign the bottom navigation bar to match 5-tab layout (Избранное → Галерея → **+** → Коллекции → Ещё), add a bottom sheet with camera/gallery/file actions on the **+** button, add English language support, and ensure full responsive upscaling.

## Proposed Changes

### Navigation & Pages

#### [MODIFY] [home_page.dart](file:///home/kurumi/code/temp/MTCapp/lib/features/home/presentation/pages/home_page.dart)

- Rewrite bottom navbar: **5 items** — Избранное (star), Галерея (photo), **+ (add)**, Коллекции (folder), Ещё (more_horiz)
- `IndexedStack` pages: `FavoritesPage`, `GalleryPage`, `CollectionsPage`, `MorePage` (+ is action-only)
- Bottom sheet on "+" tap: 3 options — Сделать фото (camera), Выбрать из галереи (image picker), Загрузить файл (file browser) — each currently just closes the sheet
- Responsive sizing via `MediaQuery` for icons, text, and padding

#### [NEW] [favorites_page.dart](file:///home/kurumi/code/temp/MTCapp/lib/features/home/presentation/pages/favorites_page.dart)

- Stub page with star icon and "Избранное" / "Your favorites will appear here"

#### [NEW] [more_page.dart](file:///home/kurumi/code/temp/MTCapp/lib/features/home/presentation/pages/more_page.dart)

- Stub page with menu items: Корзина (disabled/future), Скачать (future), Импорт из облака (future)
- All items shown as disabled/coming-soon

#### [DELETE] [profile_page.dart](file:///home/kurumi/code/temp/MTCapp/lib/features/home/presentation/pages/profile_page.dart)

- Replaced by `MorePage`

---

### Localization

#### [NEW] [app_localizations.dart](file:///home/kurumi/code/temp/MTCapp/lib/core/l10n/app_localizations.dart)

- Custom `LocalizationsDelegate` supporting `ru` and `en`
- String map with all UI labels used in the app

#### [MODIFY] [main.dart](file:///home/kurumi/code/temp/MTCapp/lib/main.dart)

- Add `localizationsDelegates` and `supportedLocales` to `MaterialApp`

#### [MODIFY] All pages

- Replace hardcoded Russian strings with `AppLocalizations.of(context).xxx`

---

### Responsive Upscaling

All widgets will use `MediaQuery.sizeOf(context)` for:

- Icon sizes
- Font sizes
- Padding/spacing

## Verification Plan

### Automated Tests

- `flutter analyze` — no warnings
- Visual check via `flutter run -d linux` or Android emulator

### Manual Verification

- Navbar shows 5 items in correct order
- "+" opens bottom sheet with 3 options
- Switching locale shows English labels
- App scales properly on different screen sizes
