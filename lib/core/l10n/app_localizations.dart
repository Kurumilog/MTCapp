/// 1) Общее назначение:
///    Обеспечивает поддержку многоязычности (RU/EN) в приложении.
/// 2) С какими файлами связан:
///    - Используется во всех UI-компонентах через AppLocalizations.of(context).
///    - Настраивается в lib/main.dart.
/// 3) Описание функций:
///    - AppLocalizations: Класс-контейнер для строк перевода.
///    - delegate: Делегат для загрузки локализации в MaterialApp.
///    - get(): Метод для получения строки по ключу с фолбеком на английский.
library;

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('ru'), Locale('en')];

  static final Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      // Navigation
      'favorites': 'Любимое',
      'gallery': 'Галерея',
      'add': 'Добавить',
      'collections': 'Коллекции',
      'more': 'Ещё',

      // Add sheet
      'addTitle': 'Добавить',
      'takePhoto': 'Сделать фото',
      'chooseFromGallery': 'Выбрать из галереи',
      'uploadFile': 'Загрузить файл',

      // Pages
      'favoritesTitle': 'Любимое',
      'favoritesSubtitle': 'Здесь появятся ваши любимые файлы',
      'galleryTitle': 'Галерея',
      'gallerySubtitle': 'Здесь будут ваши файлы',
      'collectionsTitle': 'Коллекции',
      'collectionsSubtitle': 'Здесь будут ваши альбомы',

      // More page
      'moreTitle': 'Ещё',
      'settings': 'Настройки',
      'trash': 'Корзина',
      'download': 'Отправить по ссылке',
      'cloudImport': 'Корпоративное облако',
      'comingSoon': 'Скоро',

      // Settings
      'settingsTitle': 'Настройки',
      'appLanguage': 'Язык приложения',
      'appTheme': 'Тема приложения',
      'lightTheme': 'Светлая',
      'darkTheme': 'Тёмная',
      'russian': 'Русский',
      'english': 'English',

      // App
      'appTitle': 'MTC Cloud',

      // Auth
      'welcome': 'Добро пожаловать',
      'login': 'Войти',
      'register': 'Регистрация',
      'email': 'Email',
      'password': 'Пароль',
      'confirmPassword': 'Повторите пароль',
      'name': 'Имя',
      'noAccount': 'Нет аккаунта?',
      'hasAccount': 'Уже есть аккаунт?',
      'username': 'Имя пользователя',
      'firstName': 'Имя',
      'lastName': 'Фамилия',
      'phoneNumber': 'Номер телефона',
      'registerAction': 'Зарегистрироваться',
      'loginAction': 'Войти',
      'registerTitle': 'Зарегистрируйтесь',
      'noAccountPrompt': 'Еще нет аккаунта? ',
      'hasAccountPrompt': 'Уже зарегистрированы? ',
      'fillAllFields': 'Заполните все поля',
      'passwordTooShort': 'Пароль должен быть не менее 8 символов',
        'passwordInvalidChars':
          'Пароль может содержать только английские буквы, цифры и символы',
      'passwordsDoNotMatch': 'Пароли не совпадают',
        'phoneInvalidFormat':
          'Номер телефона может содержать только + и цифры',
      'authError': 'Ошибка',
      'profile': 'Профиль',
      'editProfile': 'Личные данные',
      'surName': 'Отчество',
      'saveChanges': 'Сохранить',
      'comingSoonFeature': 'Функция скоро будет доступна',
      'loginToSeeProfile': 'Войдите в аккаунт',
      'usernameCannotChange': 'Имя пользователя нельзя изменить',
      'enterCurrentPassword': 'Для сохранения изменений введите текущий пароль',
      'currentPassword': 'Текущий пароль',
      'newPassword': 'Новый пароль',
      'confirmNewPassword': 'Подтвердите новый пароль',
      'changePassword': 'Сменить пароль',
      'passwordChanged': 'Пароль успешно изменен',
      'wrongCurrentPassword': 'Текущий пароль указан неверно',
      'passwordDuplicate': 'Новый пароль должен отличаться от текущего',
      'cancel': 'Отмена',
      'confirm': 'Подтвердить',
      'profileUpdated': 'Данные успешно обновлены',
      'noChanges': 'Вы ничего не изменили',
      'wrongPassword': 'Неверный пароль',
      'updateError': 'Ошибка обновления профиля',
      'logout': 'Выйти из аккаунта',
      'logoutConfirm': 'Вы уверены, что хотите выйти?',
    },
    'en': {
      // Navigation
      'favorites': 'Favorites',
      'gallery': 'Gallery',
      'add': 'Add',
      'collections': 'Collections',
      'more': 'More',

      // Add sheet
      'addTitle': 'Add',
      'takePhoto': 'Take photo',
      'chooseFromGallery': 'Choose from gallery',
      'uploadFile': 'Upload file',

      // Pages
      'favoritesTitle': 'Favorites',
      'favoritesSubtitle': 'Your favorite files will appear here',
      'galleryTitle': 'Gallery',
      'gallerySubtitle': 'Your files will be here',
      'collectionsTitle': 'Collections',
      'collectionsSubtitle': 'Your albums will be here',

      // More page
      'moreTitle': 'More',
      'settings': 'Settings',
      'trash': 'Trash',
      'download': 'Share by link',
      'cloudImport': 'Corporate cloud',
      'comingSoon': 'Coming soon',

      // Settings
      'settingsTitle': 'Settings',
      'appLanguage': 'App language',
      'appTheme': 'App theme',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'russian': 'Русский',
      'english': 'English',

      // App
      'appTitle': 'MTC Cloud',

      // Auth
      'welcome': 'Welcome',
      'login': 'Log in',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm password',
      'name': 'Name',
      'noAccount': 'No account?',
      'hasAccount': 'Already have an account?',
      'username': 'Username',
      'firstName': 'First name',
      'lastName': 'Last name',
      'phoneNumber': 'Phone number',
      'registerAction': 'Register',
      'loginAction': 'Log in',
      'registerTitle': 'Create account',
      'noAccountPrompt': "Don't have an account? ",
      'hasAccountPrompt': 'Already registered? ',
      'fillAllFields': 'Fill in all fields',
      'passwordTooShort': 'Password must be at least 8 characters',
        'passwordInvalidChars':
          'Password can contain only English letters, digits and symbols',
      'passwordsDoNotMatch': 'Passwords do not match',
        'phoneInvalidFormat':
          'Phone number can contain only + and digits',
      'authError': 'Error',
      'profile': 'Profile',
      'editProfile': 'Personal data',
      'surName': 'Middle name',
      'saveChanges': 'Save',
      'comingSoonFeature': 'This feature is coming soon',
      'loginToSeeProfile': 'Log in to your account',
      'usernameCannotChange': 'Username cannot be changed',
      'enterCurrentPassword': 'Enter your current password to save changes',
      'currentPassword': 'Current password',
      'newPassword': 'New password',
      'confirmNewPassword': 'Confirm new password',
      'changePassword': 'Change password',
      'passwordChanged': 'Password changed successfully',
      'wrongCurrentPassword': 'Current password is incorrect',
      'passwordDuplicate': 'New password must be different from current',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'profileUpdated': 'Profile updated successfully',
      'noChanges': 'No changes were made',
      'wrongPassword': 'Wrong password',
      'updateError': 'Profile update error',
      'logout': 'Log out',
      'logoutConfirm': 'Are you sure you want to log out?',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  // Navigation
  String get favorites => get('favorites');
  String get gallery => get('gallery');
  String get add => get('add');
  String get collections => get('collections');
  String get more => get('more');

  // Add sheet
  String get addTitle => get('addTitle');
  String get takePhoto => get('takePhoto');
  String get chooseFromGallery => get('chooseFromGallery');
  String get uploadFile => get('uploadFile');

  // Pages
  String get favoritesTitle => get('favoritesTitle');
  String get favoritesSubtitle => get('favoritesSubtitle');
  String get galleryTitle => get('galleryTitle');
  String get gallerySubtitle => get('gallerySubtitle');
  String get collectionsTitle => get('collectionsTitle');
  String get collectionsSubtitle => get('collectionsSubtitle');

  // More page
  String get moreTitle => get('moreTitle');
  String get settings => get('settings');
  String get trash => get('trash');
  String get download => get('download');
  String get cloudImport => get('cloudImport');
  String get comingSoon => get('comingSoon');

  // Settings
  String get settingsTitle => get('settingsTitle');
  String get appLanguage => get('appLanguage');
  String get appTheme => get('appTheme');
  String get lightTheme => get('lightTheme');
  String get darkTheme => get('darkTheme');
  String get russian => get('russian');
  String get english => get('english');

  // App
  String get appTitle => get('appTitle');

  // Auth
  String get welcome => get('welcome');
  String get login => get('login');
  String get register => get('register');
  String get email => get('email');
  String get password => get('password');
  String get confirmPassword => get('confirmPassword');
  String get name => get('name');
  String get noAccount => get('noAccount');
  String get hasAccount => get('hasAccount');
  String get username => get('username');
  String get firstName => get('firstName');
  String get lastName => get('lastName');
  String get phoneNumber => get('phoneNumber');
  String get registerAction => get('registerAction');
  String get loginAction => get('loginAction');
  String get registerTitle => get('registerTitle');
  String get noAccountPrompt => get('noAccountPrompt');
  String get hasAccountPrompt => get('hasAccountPrompt');
  String get fillAllFields => get('fillAllFields');
  String get passwordTooShort => get('passwordTooShort');
  String get passwordInvalidChars => get('passwordInvalidChars');
  String get passwordsDoNotMatch => get('passwordsDoNotMatch');
  String get phoneInvalidFormat => get('phoneInvalidFormat');
  String get authError => get('authError');
  String get profile => get('profile');
  String get editProfile => get('editProfile');
  String get surName => get('surName');
  String get saveChanges => get('saveChanges');
  String get comingSoonFeature => get('comingSoonFeature');
  String get loginToSeeProfile => get('loginToSeeProfile');
  String get usernameCannotChange => get('usernameCannotChange');
  String get enterCurrentPassword => get('enterCurrentPassword');
  String get currentPassword => get('currentPassword');
  String get newPassword => get('newPassword');
  String get confirmNewPassword => get('confirmNewPassword');
  String get changePassword => get('changePassword');
  String get passwordChanged => get('passwordChanged');
  String get wrongCurrentPassword => get('wrongCurrentPassword');
  String get passwordDuplicate => get('passwordDuplicate');
  String get cancel => get('cancel');
  String get confirm => get('confirm');
  String get profileUpdated => get('profileUpdated');
  String get noChanges => get('noChanges');
  String get wrongPassword => get('wrongPassword');
  String get updateError => get('updateError');
  String get logout => get('logout');
  String get logoutConfirm => get('logoutConfirm');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
