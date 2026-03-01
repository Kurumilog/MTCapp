/// 1) Общее назначение:
///    Централизованные валидаторы пользовательского ввода (пароль, телефон).
/// 2) С какими файлами связан:
///    - `login_page.dart`, `registration_page.dart`.
///    - `settings_page.dart` (смена пароля).
///    - `edit_profile_page.dart` (проверка телефона и пароля подтверждения).
/// 3) Описание функций:
///    - `isAsciiPassword()`: разрешает только английские буквы, цифры и ASCII-символы.
///    - `isPhoneNumber()`: разрешает только цифры и опциональный ведущий `+`.
library;

class InputValidators {
  InputValidators._();

  /// Только печатные ASCII-символы без пробела: [! ... ~]
  /// Это покрывает английские буквы, цифры и спецсимволы.
  static final RegExp _asciiPasswordRegex = RegExp(r'^[\x21-\x7E]+$');

  /// Телефон: опциональный '+' в начале и далее только цифры.
  static final RegExp _phoneRegex = RegExp(r'^\+?\d+$');

  static bool isAsciiPassword(String value) {
    return _asciiPasswordRegex.hasMatch(value);
  }

  static bool isPhoneNumber(String value) {
    return _phoneRegex.hasMatch(value);
  }
}
