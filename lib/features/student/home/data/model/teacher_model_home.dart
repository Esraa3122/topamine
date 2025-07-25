class TeacherModel {
  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.governorate,
    required this.subject,
    required this.avatarUrl,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json, String docId) {
    return TeacherModel(
      id: docId,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      governorate: json['governorate']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      avatarUrl: json['avatar']?.toString() ?? '',
    );
  }
  final String id;
  final String name;
  final String email;
  final String phone;
  final String governorate;
  final String subject;
  final String avatarUrl;
}
