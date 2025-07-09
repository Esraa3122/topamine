import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/core/enums/rule_register.dart';

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
    this.grade,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'role')
  final UserRole userRole;
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

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
