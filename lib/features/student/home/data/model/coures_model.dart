import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/student/home/data/model/lecture_model.dart';

class CourseModel {
  CourseModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.capacity,
    required this.enrolledCount,
    required this.gradeLevel,
    required this.term,
    required this.teacherEmail,
    required this.teacherId,
    required this.teacherName,
    required this.status,
    required this.createdAt,
    required this.sectionTitle,
    required this.lectures,
  });
  // ─────────────────────── factory ‑ from firestore ───────────────
  factory CourseModel.fromJson(
    Map<String, dynamic> json,
    String docId,
  ) {
    return CourseModel(
      id: docId,
      imageUrl: (json['imageUrl'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subTitle: (json['subTitle'] as String?) ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      startDate: (json['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (json['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
      gradeLevel: (json['gradeLevel'] as String?) ?? '',
      term: (json['term'] as String?) ?? '',
      teacherEmail: (json['teacherEmail'] as String?) ?? '',
      teacherId: (json['teacherId'] as String?) ?? '',
      teacherName: (json['teacherName'] as String?) ?? '',
      sectionTitle: (json['sectionTitle'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lectures:
          (json['lectures'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(LectureModel.fromJson)
              .toList() ??
          [],
    );
  }
  // ──────────────────────────── fields ────────────────────────────
  final String id;
  final String imageUrl;
  final String title;
  final String subTitle;
  final int price;
  final DateTime startDate;
  final DateTime endDate;
  final int capacity;
  final int enrolledCount;
  final String gradeLevel;
  final String term;
  final String teacherEmail;
  final String teacherId;
  final String teacherName;
  final String sectionTitle;
  final String status;
  final DateTime createdAt;
  final List<LectureModel> lectures;

  // ─────────────────────────── to‑json ────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'subTitle': subTitle,
      'price': price,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'capacity': capacity,
      'enrolledCount': enrolledCount,
      'gradeLevel': gradeLevel,
      'term': term,
      'teacherEmail': teacherEmail,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'sectionTitle': sectionTitle,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'lectures': lectures.map((e) => e.toJson()).toList(),
    };
  }
}
