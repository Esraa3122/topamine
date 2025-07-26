// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courses_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoursesModel _$CoursesModelFromJson(Map<String, dynamic> json) => CoursesModel(
  title: json['title'] as String,
  teacherName: json['teacherName'] as String,
  id: json['id'] as String?,
  enrolledDate: json['enrolled_date'] as String?,
  gradeLevel: json['gradeLevel'] as String?,
  enrolledCount: (json['enrolledCount'] as num?)?.toInt(),
  imageUrl: json['imageUrl'] as String?,
  subject: json['subject'] as String?,
  teacherId: json['teacherId'] as String?,
  teacherEmail: json['teacherEmail'] as String?,
  term: json['term'] as String?,
  subTitle: json['subTitle'] as String?,
  status: json['status'] as String?,
  startDate: _fromTimestamp(json['startDate']),
  price: json['price'] as num?,
  endDate: _fromTimestamp(json['endDate']),
  createdAt: _fromTimestamp(json['createdAt']),
  lectures: (json['lectures'] as List<dynamic>?)
      ?.map((e) => LectureModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  capacity: (json['capacity'] as num?)?.toInt(),
);

Map<String, dynamic> _$CoursesModelToJson(CoursesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'teacherName': instance.teacherName,
      'enrolled_date': instance.enrolledDate,
      'gradeLevel': instance.gradeLevel,
      'subject': instance.subject,
      'imageUrl': instance.imageUrl,
      'enrolledCount': instance.enrolledCount,
      'teacherId': instance.teacherId,
      'teacherEmail': instance.teacherEmail,
      'term': instance.term,
      'subTitle': instance.subTitle,
      'status': instance.status,
      'startDate': _toTimestamp(instance.startDate),
      'price': instance.price,
      'endDate': _toTimestamp(instance.endDate),
      'createdAt': _toTimestamp(instance.createdAt),
      'capacity': instance.capacity,
      'lectures': instance.lectures?.map((e) => e.toJson()).toList(),
    };

LectureModel _$LectureModelFromJson(Map<String, dynamic> json) => LectureModel(
  title: json['title'] as String,
  videoUrl: json['videoUrl'] as String,
  txtUrl: json['txtUrl'] as String,
  docUrl: json['docUrl'] as String,
);

Map<String, dynamic> _$LectureModelToJson(LectureModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'videoUrl': instance.videoUrl,
      'txtUrl': instance.txtUrl,
      'docUrl': instance.docUrl,
    };
