import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/enums/status_register.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.userRole,
    required this.phone,
    required this.governorate,
    this.userImage,
    this.blocked = false,
    this.grade,
    this.subject,
    this.status,
    this.experiance,
    this.info,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'role', fromJson: _roleFromJson, toJson: _roleToJson)
  final UserRole userRole;

  @JsonKey(name: 'blocked', defaultValue: false)
  final bool blocked;

  @JsonKey(name: 'id')
  final String userId;

  @JsonKey(name: 'name')
  final String userName;

  @JsonKey(name: 'email')
  final String userEmail;

  @JsonKey(name: 'avatar')
  final String? userImage;

  @JsonKey(name: 'governorate')
  final String governorate;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'grade')
  final String? grade;

  @JsonKey(name: 'subject')
  final String? subject;

  @JsonKey(name: 'experiance')
  final String? experiance;

  @JsonKey(name: 'info')
  final String? info;

  @JsonKey(
    name: 'status',
    fromJson: mapStringToAccountStatus,
    toJson: mapAccountStatusToString,
  )
  final AccountStatus? status;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? userId,
    String? userEmail,
    String? userName,
    UserRole? userRole,
    bool? blocked,
    String? phone,
    String? governorate,
    String? userImage,
    String? grade,
    String? subject,
    AccountStatus? status,
    String? info,
    String? experiance,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      blocked: blocked ?? this.blocked,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      userImage: userImage ?? this.userImage,
      grade: grade ?? this.grade,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      experiance: experiance ?? this.experiance,
      info: info ?? this.info,
    );
  }
}

UserRole _roleFromJson(String role) {
  try {
    return UserRole.values.firstWhere((e) => e.name == role);
  } catch (_) {
    throw Exception('Invalid user role: $role');
  }
}



String _roleToJson(UserRole role) => role.name;
