// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UpdateRequest _$UpdateRequestFromJson(Map<String, dynamic> json) {
  return _UpdateRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateRequest {
  /// Текущий пароль — обязательное поле для подтверждения изменений.
  String get password => throw _privateConstructorUsedError;

  /// Новый email (необязательно).
  String? get email => throw _privateConstructorUsedError;

  /// Новое имя (необязательно).
  String? get firstName => throw _privateConstructorUsedError;

  /// Новая фамилия (необязательно).
  String? get lastName => throw _privateConstructorUsedError;

  /// Новое отчество (необязательно).
  String? get surName => throw _privateConstructorUsedError;

  /// Номер телефона (необязательно).
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this UpdateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateRequestCopyWith<UpdateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateRequestCopyWith<$Res> {
  factory $UpdateRequestCopyWith(
    UpdateRequest value,
    $Res Function(UpdateRequest) then,
  ) = _$UpdateRequestCopyWithImpl<$Res, UpdateRequest>;
  @useResult
  $Res call({
    String password,
    String? email,
    String? firstName,
    String? lastName,
    String? surName,
    String? phoneNumber,
  });
}

/// @nodoc
class _$UpdateRequestCopyWithImpl<$Res, $Val extends UpdateRequest>
    implements $UpdateRequestCopyWith<$Res> {
  _$UpdateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? surName = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(
      _value.copyWith(
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            surName: freezed == surName
                ? _value.surName
                : surName // ignore: cast_nullable_to_non_nullable
                      as String?,
            phoneNumber: freezed == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateRequestImplCopyWith<$Res>
    implements $UpdateRequestCopyWith<$Res> {
  factory _$$UpdateRequestImplCopyWith(
    _$UpdateRequestImpl value,
    $Res Function(_$UpdateRequestImpl) then,
  ) = __$$UpdateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String password,
    String? email,
    String? firstName,
    String? lastName,
    String? surName,
    String? phoneNumber,
  });
}

/// @nodoc
class __$$UpdateRequestImplCopyWithImpl<$Res>
    extends _$UpdateRequestCopyWithImpl<$Res, _$UpdateRequestImpl>
    implements _$$UpdateRequestImplCopyWith<$Res> {
  __$$UpdateRequestImplCopyWithImpl(
    _$UpdateRequestImpl _value,
    $Res Function(_$UpdateRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? password = null,
    Object? email = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? surName = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(
      _$UpdateRequestImpl(
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        surName: freezed == surName
            ? _value.surName
            : surName // ignore: cast_nullable_to_non_nullable
                  as String?,
        phoneNumber: freezed == phoneNumber
            ? _value.phoneNumber
            : phoneNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateRequestImpl implements _UpdateRequest {
  const _$UpdateRequestImpl({
    required this.password,
    this.email,
    this.firstName,
    this.lastName,
    this.surName,
    this.phoneNumber,
  });

  factory _$UpdateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateRequestImplFromJson(json);

  /// Текущий пароль — обязательное поле для подтверждения изменений.
  @override
  final String password;

  /// Новый email (необязательно).
  @override
  final String? email;

  /// Новое имя (необязательно).
  @override
  final String? firstName;

  /// Новая фамилия (необязательно).
  @override
  final String? lastName;

  /// Новое отчество (необязательно).
  @override
  final String? surName;

  /// Номер телефона (необязательно).
  @override
  final String? phoneNumber;

  @override
  String toString() {
    return 'UpdateRequest(password: $password, email: $email, firstName: $firstName, lastName: $lastName, surName: $surName, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateRequestImpl &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.surName, surName) || other.surName == surName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    password,
    email,
    firstName,
    lastName,
    surName,
    phoneNumber,
  );

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateRequestImplCopyWith<_$UpdateRequestImpl> get copyWith =>
      __$$UpdateRequestImplCopyWithImpl<_$UpdateRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateRequestImplToJson(this);
  }
}

abstract class _UpdateRequest implements UpdateRequest {
  const factory _UpdateRequest({
    required final String password,
    final String? email,
    final String? firstName,
    final String? lastName,
    final String? surName,
    final String? phoneNumber,
  }) = _$UpdateRequestImpl;

  factory _UpdateRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateRequestImpl.fromJson;

  /// Текущий пароль — обязательное поле для подтверждения изменений.
  @override
  String get password;

  /// Новый email (необязательно).
  @override
  String? get email;

  /// Новое имя (необязательно).
  @override
  String? get firstName;

  /// Новая фамилия (необязательно).
  @override
  String? get lastName;

  /// Новое отчество (необязательно).
  @override
  String? get surName;

  /// Номер телефона (необязательно).
  @override
  String? get phoneNumber;

  /// Create a copy of UpdateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateRequestImplCopyWith<_$UpdateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
