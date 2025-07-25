import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
import 'package:test/features/student/home/data/model/teacher_model_home.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // all courses
  Future<List<CourseModel>> getAllCourses() async {
    final snapshot = await _firestore.collection('courses').get();

    return snapshot.docs.map((doc) {
      return CourseModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

  // some courses tpo 5
  Future<List<CourseModel>> getSuggestedCourses({int limit = 5}) async {
    final snapshot = await _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return CourseModel.fromJson(doc.data(), doc.id);
    }).toList();
  }

// teacher
  Future<List<TeacherModel>> fetchTeachers() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('teacher')
        .get();
    return snapshot.docs
        .map((doc) => TeacherModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
