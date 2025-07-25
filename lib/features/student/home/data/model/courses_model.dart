import 'package:freezed_annotation/freezed_annotation.dart';

part 'courses_model.g.dart';

@JsonSerializable()
class CoursesModel {
  CoursesModel({
    required this.title,
    required this.teacherName,
    this.id,
    this.enrolledDate,
    this.gradeLevel,
    this.enrolledCount,
    this.imageUrl,
    this.subject,
    this.teacherId,
    this.teacherEmail,
    this.term,
    this.subTitle,
    this.status,
    this.startDate,
    this.price,
    this.endDate,
    this.createdAt,
    this.lecturesModel,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) =>
      _$CoursesModelFromJson(json);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'teacherName')
  final String teacherName;
  @JsonKey(name: 'enrolled_date')
  final String? enrolledDate;
  @JsonKey(name: 'gradeLevel')
  final String? gradeLevel;
  @JsonKey(name: 'subject')
  final String? subject;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'enrolledCount')
  final int? enrolledCount;
  @JsonKey(name: 'teacherid')
  final String? teacherId;
  @JsonKey(name: 'teacherEmail')
  final String? teacherEmail;
  @JsonKey(name: 'term')
  final String? term;
  @JsonKey(name: 'subTitle')
  final String? subTitle;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'startDate')
  final String? startDate;
  @JsonKey(name: 'price')
  final String? price;
  @JsonKey(name: 'endDate')
  final String? endDate;
  @JsonKey(name: 'createdAt')
  final String? createdAt;
  @JsonKey(name: 'lecturesModel')
  final LecturesModel? lecturesModel;

  Map<String, dynamic> toJson() => _$CoursesModelToJson(this);

  CoursesModel copyWith({
    String? id,
    String? title,
    String? teacherName,
    String? enrolledDate,
    String? gradeLevel,
    int? enrolledCount,
    String? imageUrl,
    String? teacherId,
    String? teacherEmail,
    String? term,
    String? subTitle,
    String? startDate,
    String? price,
    String? endDate,
    String? createdAt,
    LecturesModel? lecturesModel,
    String? status,
    String? subject,
  }) {
    return CoursesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      teacherName: teacherName ?? this.teacherName,
      enrolledDate: enrolledDate ?? this.enrolledDate,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      imageUrl: imageUrl ?? this.imageUrl,
      teacherId: teacherId ?? this.teacherId,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      term: term ?? this.term,
      subTitle: subTitle ?? this.subTitle,
      startDate: startDate ?? this.startDate,
      price: price ?? this.price,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      lecturesModel: lecturesModel ?? this.lecturesModel,
      status: status ?? this.status,
      subject: subject ?? this.subject,
    );
  }
}


@JsonSerializable()
class LecturesModel {
  LecturesModel({
    required this.pdfUrl,
    required this.title,
    required this.txtUrl,
    required this.videoUrl,
  });

  factory LecturesModel.fromJson(Map<String, dynamic> json) =>
      _$LecturesModelFromJson(json);

  @JsonKey(name: 'pdfUrl')
  final String pdfUrl;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'txtUrl')
  final String txtUrl;
  @JsonKey(name: 'videoUrl')
  final String videoUrl;

  Map<String, dynamic> toJson() => _$LecturesModelToJson(this);

  LecturesModel copyWith({
    String? pdfUrl,
    String? title,
    String? txtUrl,
    String? videoUrl,
  }) {
    return LecturesModel(
      pdfUrl: pdfUrl ?? this.pdfUrl,
      title: title ?? this.title,
      txtUrl: txtUrl ?? this.txtUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }
}
