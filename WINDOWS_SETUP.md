# Windows Setup Guide для MTCapp

Полное руководство по настройке окружения и запуску Flutter приложения MTCapp на Windows от начала и до конца.

---

## Этап 1: Системные требования

**Минимум:**
- **ОС:** Windows 10 или выше (build 19041+)
- **RAM:** 8 GB (рекомендуется 16 GB)
- **Диск:** 10+ GB свободного места (для SDK, эмулятора, build артефактов)
- **Интернет:** Стабильное соединение для загрузки компонентов

**Проверка версии Windows:**
```powershell
Get-ComputerInfo | Select-Object OsName, OsVersion
```

---

## Этап 2: Установка Chocolatey (пакетный менеджер)

Chocolatey упрощает установку инструментов командой.

### 2.1 Открыть PowerShell от администратора

1. Нажми `Win + X` → выбери **Windows PowerShell (Admin)**
2. Если появится запрос UAC → нажми **Да**

### 2.2 Разрешить выполнение скриптов

В PowerShell выполни:
```powershell
Get-ExecutionPolicy
```

Если результат `Restricted`, выполни:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Подтверди вводом `Y` и Enter.

### 2.3 Установить Chocolatey

Скопируй и выполни в PowerShell:
```powershell
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Подождите завершения (2-3 минуты).

### 2.4 Проверить установку

```powershell
choco --version
```

Должна вывести версию (например, `2.4.1`).

---

## Этап 3: Установка необходимых инструментов через Chocolatey

Выполни в PowerShell (Admin):

```powershell
choco install -y git
choco install -y visualstudio2022buildtools --includeRecommended
choco install -y android-studio
choco install -y adb
choco install -y vscode
```

Параметр `-y` автоматически подтверждает установку.

**Время:** 15-30 минут в зависимости от скорости интернета и диска.

---

## Этап 4: Установка Flutter SDK вручную

Chocolatey может не иметь самую свежую версию Flutter, поэтому установим вручную.

### 4.1 Скачать Flutter SDK

1. Перейди на https://flutter.dev/docs/get-started/install/windows
2. Нажми кнопку **Download** (latest stable)
3. Файл `flutter_windows_x.x.x-stable.zip` загрузится

### 4.2 Распаковать и разместить

1. Создай директорию: `C:\src` (или любая без спецсимволов и пробелов)
2. Распакуй zip в `C:\src\flutter`
3. Убедись, что файл `flutter/bin/flutter.bat` существует

### 4.3 Добавить Flutter в PATH

1. Нажми `Win + X` → **System**
2. В окне: **Advanced system settings** → **Environment Variables**
3. Под **User variables** → нажми **New**
   - Переменная: `PATH`
   - Значение: `C:\src\flutter\bin`
4. Нажми **OK** и закрой окна

### 4.4 Перезагрузить PowerShell

Закрой и открой новое окно PowerShell (Admin).

### 4.5 Проверить установку Flutter

```powershell
flutter --version
flutter doctor
```

Команда `flutter doctor` покажет статус всех компонентов.

---

## Этап 5: Конфигурация Android SDK

### 5.1 Открыть Android Studio

1. Запусти Android Studio (установлена на шаге 3)
2. При первом запуске выбери **Do not import settings** → **OK**

### 5.2 Установить Android SDK Components

1. Menu → **Tools** → **SDK Manager**
2. Во вкладке **SDK Platforms** отметь:
   - ✓ **Android 14 (API 34)** (для текущего)
   - ✓ **Android 13 (API 33)**
3. Во вкладке **SDK Tools** отметь:
   - ✓ **Android SDK Build-Tools** (последняя версия)
   - ✓ **Android Emulator**
   - ✓ **Android SDK Platform-Tools**
4. Нажми **Apply** → **OK**
5. Примите лицензии нажатием **Accept All** → **Install**

**Время:** 10-15 минут.

### 5.3 Установить переменные окружения (опционально)

Если Flutter doctor жалуется на Android SDK path:

1. **Environment Variables** (как на шаге 4.3)
2. Создай новую переменную:
   - Имя: `ANDROID_HOME`
   - Значение: `C:\Users\[ТвоеИмя]\AppData\Local\Android\sdk`
3. **OK** → закрой окна

### 5.4 Запустить Android Emulator

1. Android Studio → **Device Manager** (слева)
2. Нажми **Create device** → выбери **Pixel 5** → **Next** → **Download** (если нужно) → **Finish**
3. Нажми кнопку ▶️ рядом с созданным устройством
4. Подожди 30-60 секунд пока эмулятор загрузится

---

## Этап 6: Установка VS Code и расширений

### 6.1 Запустить VS Code

Если не установлен, выполни:
```powershell
choco install -y vscode
```

### 6.2 Установить расширения

1. Запусти VS Code
2. Нажми `Ctrl + Shift + X` (Extensions)
3. Установи:
   - **Flutter** (Dart Code) — `VentureLab.flutter`
   - **Dart** (Dart Code) — `VentureLab.dart-code`
   - **Dart Data Class Generator** (опционально) — `hzgood.dart-data-class-generator`

Процесс установки автоматически настроит Flutter интеграцию.

### 6.3 Проверить интеграцию

1. `Ctrl + Shift + P` → введи `Flutter: Run Flutter Doctor`
2. Должен открыться встроенный терминал с выводом `flutter doctor`

---

## Этап 7: Клонирование проекта и подготовка

### 7.1 Клонировать репозиторий

Открой PowerShell и выполни:
```powershell
cd C:\Users\[ТвоеИмя]\code  # или выбери свою директорию
git clone https://github.com/[твой-репо]/MTCapp.git
cd MTCapp
```

### 7.2 Получить зависимости

```powershell
flutter pub get
```

Это загрузит все пакеты из `pubspec.yaml` (~3-5 минут).

### 7.3 Проверить анализ кода

```powershell
flutter analyze
```

Должно вывести `No issues found!` или список исправляемых проблем.

---

## Этап 8: Запуск приложения

### Вариант А: На Android Emulator

```powershell
# Проверить доступные устройства
flutter devices

# Запустить на эмуляторе (если он уже работает)
flutter run

# Или явно указать эмулятор
flutter run -d <device-id>
```

**Первый запуск:** 5-15 минут (создание APK и установка).

### Вариант Б: На реальном Android устройстве

1. Подключи телефон USB кабелем
2. На телефоне: **Настройки** → **О приложениях** → 7x тап на **Номер сборки** → Активируй **Режим разработчика**
3. **Настройки** → **Параметры разработчика** → **USB Отладка** → Включи
4. В PowerShell:
   ```powershell
   flutter devices
   ```
   Должно появиться твое устройство в списке.
5. Запусти:
   ```powershell
   flutter run
   ```

### Вариант В: Windows Desktop (Desktop Mode)

```powershell
# Включить Windows Desktop
flutter config --enable-windows-desktop

# Проверить
flutter devices

# Запустить
flutter run -d windows
```

---

## Этап 9: Hot Reload и отладка

### Hot Reload (во время запуска `flutter run`)

- **r** — Hot reload (перезагрузить код, сохранить state)
- **R** — Hot restart (перезагрузить с нулевым state)
- **q** — Выход из приложения

### Отладка в VS Code

1. Открой проект в VS Code: `code .`
2. Поставь точку останова (breakpoint) на строку кода
3. `F5` или **Run** → **Start Debugging**
4. Приложение запустится с отладчиком; при попадании на точку останова выполнение приостановится

---

## Этап 10: Сборка Release (для распределения)

### Android APK

```powershell
flutter build apk --release
```

APK файл будет в: `build\app\outputs\flutter-apk\app-release.apk`

### Android App Bundle (для Google Play)

```powershell
flutter build appbundle --release
```

AAB файл будет в: `build\app\outputs\bundle\release\app-release.aab`

### Windows EXE

```powershell
flutter build windows --release
```

EXE будет в: `build\windows\runner\Release\mtc_app.exe`

---

## Этап 11: Решение частых проблем

### Проблема: `flutter: command not found`

**Решение:**
```powershell
# Проверить PATH
$env:PATH

# Перезагрузить окружение
$profile
# Если файл не существует, создать:
New-Item -Path $PROFILE -Type File -Force
# Добавить в файл:
# $env:Path += ";C:\src\flutter\bin"
```

Затем закрыть и открыть PowerShell заново.

### Проблема: `Android SDK not found`

**Решение:**
```powershell
flutter config --android-sdk C:\Users\[ТвоеИмя]\AppData\Local\Android\sdk
```

### Проблема: Эмулятор не запускается

1. Открой Android Studio → **Device Manager**
2. Нажми меню (три точки) → **Wipe Data** → запусти заново
3. Если не поможет, удали устройство и создай новое

### Проблема: `Gradle build failed`

```powershell
# Очистить build кэш
flutter clean

# Пересобрать
flutter pub get
flutter run
```

### Проблема: Много ошибок в `flutter analyze`

```powershell
# Обновить зависимости
flutter pub upgrade

# Переанализировать
flutter analyze
```

---

## Этап 12: Дальнейшая разработка

### Структура проекта

```
MTCapp/
├── lib/
│   ├── main.dart              # Точка входа
│   ├── core/                  # Общие компоненты
│   └── features/              # Функции приложения
├── pubspec.yaml               # Зависимости
├── android/                   # Android-специфичный код
├── ios/                       # iOS-специфичный код
├── windows/                   # Windows-специфичный код
└── test/                      # Тесты
```

### Полезные команды

```powershell
# Запустить тесты
flutter test

# Форматировать код
flutter format lib/

# Статический анализ с исправлениями
flutter fix --apply

# Обновить Dart/Flutter (если нужно)
flutter upgrade
```

---

## Контрольный список перехода на работу

- [ ] Installiert Chocolatey
- [ ] Установлены Git, Visual Studio Build Tools
- [ ] Скачан и распакован Flutter SDK в `C:\src\flutter`
- [ ] Flutter добавлен в PATH (проверено `flutter --version`)
- [ ] Установлены Android SDK components (API 34, Build-Tools)
- [ ] Запущен и протестирован Android Emulator
- [ ] Установлены VS Code и расширения Flutter/Dart
- [ ] Проект клонирован, `flutter pub get` выполнен
- [ ] `flutter analyze` возвращает `No issues found!`
- [ ] `flutter run` успешно запускает приложение
- [ ] Hot reload работает (нажал **r** во время запуска)

---

## Финальная команда для быстрого старта

После выполнения всех шагов выше:

```powershell
cd C:\Users\[ТвоеИмя]\code\MTCapp
flutter pub get
flutter run
```

Приложение MTCapp должно запуститься на Android Emulator или подключенном устройстве.

---

## Ссылки и ресурсы

- **Flutter Docs:** https://flutter.dev/docs
- **Dart Docs:** https://dart.dev/guides
- **Android Studio Docs:** https://developer.android.com/studio/intro
- **VS Code + Flutter:** https://flutter.dev/docs/development/tools/vs-code

---

**Версии на момент создания:**
- Flutter: 3.22.0+ (Stable)
- Dart: 3.4.0+
- Android SDK: API 34
- Visual Studio Build Tools: 2022

---

*Последнее обновление: 4 марта 2026*
