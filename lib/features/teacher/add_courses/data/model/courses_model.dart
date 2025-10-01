import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'courses_model.g.dart';

DateTime? _fromTimestamp(dynamic timestamp) {
  if (timestamp == null) return null;
  if (timestamp is DateTime) return timestamp;
  if (timestamp is Timestamp) return timestamp.toDate();
  return null;
}

dynamic _toTimestamp(DateTime? date) {
  return date;
}

@JsonSerializable(explicitToJson: true)
class CoursesModel {
  CoursesModel({
    required this.title,
    required this.teacherName,
    this.id,
    this.gradeLevel,
    this.imageUrl,
    this.subject,
    this.teacherId,
    this.teacherEmail,
    this.term,
    this.subTitle,
    this.status = 'active',
    this.startDate,
    this.price,
    this.endDate,
    this.createdAt,
    this.lectures,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) =>
      _$CoursesModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoursesModelToJson(this);

  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'teacherName')
  final String teacherName;


  @JsonKey(name: 'gradeLevel')
  final String? gradeLevel;

  @JsonKey(name: 'subject')
  final String? subject;

  @JsonKey(name: 'imageUrl')
  final String? imageUrl;

  @JsonKey(name: 'teacherId')
  final String? teacherId;

  @JsonKey(name: 'teacherEmail')
  final String? teacherEmail;

  @JsonKey(name: 'term')
  final String? term;

  @JsonKey(name: 'subTitle')
  final String? subTitle;

  @JsonKey(name: 'status', defaultValue: 'active')
  final String? status;

  @JsonKey(name: 'startDate', fromJson: _fromTimestamp, toJson: _toTimestamp)
  final DateTime? startDate;

  @JsonKey(name: 'price')
  final num? price;

  @JsonKey(name: 'endDate', fromJson: _fromTimestamp, toJson: _toTimestamp)
  final DateTime? endDate;

  @JsonKey(name: 'createdAt', fromJson: _fromTimestamp, toJson: _toTimestamp)
  final DateTime? createdAt;

  @JsonKey(name: 'lectures')
  final List<LectureModel>? lectures;

  CoursesModel copyWith({
    String? id,
    String? title,
    String? teacherName,
    String? gradeLevel,
    String? imageUrl,
    String? teacherId,
    String? teacherEmail,
    String? term,
    String? subTitle,
    String? status,
    DateTime? startDate,
    num? price,
    DateTime? endDate,
    DateTime? createdAt,
    String? subject,
    List<LectureModel>? lectures,
  }) {
    return CoursesModel(
      id: id ?? this.id,
      title: title ?? this.title,
      teacherName: teacherName ?? this.teacherName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      imageUrl: imageUrl ?? this.imageUrl,
      teacherId: teacherId ?? this.teacherId,
      teacherEmail: teacherEmail ?? this.teacherEmail,
      term: term ?? this.term,
      subTitle: subTitle ?? this.subTitle,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      price: price ?? this.price,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      subject: subject ?? this.subject,
      lectures: lectures ?? this.lectures,
    );
  }
}

@JsonSerializable()
class LectureModel {
  LectureModel({
    required this.title,
    required this.videoUrl,
    required this.txtUrl,
    required this.docUrl,
    this.duration,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) =>
      _$LectureModelFromJson(json);

  Map<String, dynamic> toJson() => _$LectureModelToJson(this);

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'videoUrl')
  final String videoUrl;

  @JsonKey(name: 'txtUrl')
  final String? txtUrl;

  @JsonKey(name: 'docUrl')
  final String? docUrl;

  @JsonKey(name: 'duration')
  final String? duration;

  LectureModel copyWith({
    String? title,
    String? videoUrl,
    String? txtUrl,
    String? docUrl,
    String? duration
  }) {
    return LectureModel(
      title: title ?? this.title,
      videoUrl: videoUrl ?? this.videoUrl,
      txtUrl: txtUrl ?? this.txtUrl,
      docUrl: docUrl ?? this.docUrl,
      duration: duration ?? this.duration,
    );
  }
}
