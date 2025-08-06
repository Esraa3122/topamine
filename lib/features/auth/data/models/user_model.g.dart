// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['id'] as String,
  userEmail: json['email'] as String,
  userName: json['name'] as String,
  userRole: _roleFromJson(json['role'] as String),
  phone: json['phone'] as String,
  governorate: json['governorate'] as String,
  userImage: json['avatar'] as String?,
  blocked: json['blocked'] as bool? ?? false,
  grade: json['grade'] as String?,
  subject: json['subject'] as String?,
  status: mapStringToAccountStatus(json['status'] as String),
  experiance: json['experiance'] as String?,
  info: json['info'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'role': _roleToJson(instance.userRole),
  'blocked': instance.blocked,
  'id': instance.userId,
  'name': instance.userName,
  'email': instance.userEmail,
  'avatar': instance.userImage,
  'governorate': instance.governorate,
  'phone': instance.phone,
  'grade': instance.grade,
  'subject': instance.subject,
  'experiance': instance.experiance,
  'info': instance.info,
  'status': mapAccountStatusToString(instance.status),
};
