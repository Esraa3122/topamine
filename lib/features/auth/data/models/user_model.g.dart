// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['id'] as String,
  userEmail: json['email'] as String,
  userName: json['name'] as String,
  userRole: $enumDecode(_$UserRoleEnumMap, json['role']),
  phone: json['phone'] as String,
  governorate: json['governorate'] as String,
  userImage: json['avatar'] as String?,
  grade: json['grade'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'role': _$UserRoleEnumMap[instance.userRole]!,
  'id': instance.userId,
  'name': instance.userName,
  'email': instance.userEmail,
  'avatar': instance.userImage,
  'governorate': instance.governorate,
  'phone': instance.phone,
  'grade': instance.grade,
};

const _$UserRoleEnumMap = {
  UserRole.teacher: 'teacher',
  UserRole.student: 'student',
};
