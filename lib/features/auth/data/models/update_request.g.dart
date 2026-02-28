// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateRequestImpl _$$UpdateRequestImplFromJson(Map<String, dynamic> json) =>
    _$UpdateRequestImpl(
      password: json['password'] as String,
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      surName: json['surName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$$UpdateRequestImplToJson(_$UpdateRequestImpl instance) =>
    <String, dynamic>{
      'password': instance.password,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'surName': instance.surName,
      'phoneNumber': instance.phoneNumber,
    };
