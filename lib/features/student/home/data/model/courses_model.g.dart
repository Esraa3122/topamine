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
  teacherId: json['teacherid'] as String?,
  teacherEmail: json['teacherEmail'] as String?,
  term: json['term'] as String?,
  subTitle: json['subTitle'] as String?,
  status: json['status'] as String?,
  startDate: json['startDate'] as String?,
  price: json['price'] as String?,
  endDate: json['endDate'] as String?,
  createdAt: json['createdAt'] as String?,
  lecturesModel: json['lecturesModel'] == null
      ? null
      : LecturesModel.fromJson(json['lecturesModel'] as Map<String, dynamic>),
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
      'teacherid': instance.teacherId,
      'teacherEmail': instance.teacherEmail,
      'term': instance.term,
      'subTitle': instance.subTitle,
      'status': instance.status,
      'startDate': instance.startDate,
      'price': instance.price,
      'endDate': instance.endDate,
      'createdAt': instance.createdAt,
      'lecturesModel': instance.lecturesModel,
    };

LecturesModel _$LecturesModelFromJson(Map<String, dynamic> json) =>
    LecturesModel(
      pdfUrl: json['pdfUrl'] as String,
      title: json['title'] as String,
      txtUrl: json['txtUrl'] as String,
      videoUrl: json['videoUrl'] as String,
    );

Map<String, dynamic> _$LecturesModelToJson(LecturesModel instance) =>
    <String, dynamic>{
      'pdfUrl': instance.pdfUrl,
      'title': instance.title,
      'txtUrl': instance.txtUrl,
      'videoUrl': instance.videoUrl,
    };
