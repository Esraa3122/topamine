import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all courses
  Future<List<CoursesModel>> getAllCourses() async {
    final snapshot = await _firestore.collection('courses').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return CoursesModel.fromJson(data);
    }).toList();
  }

  // Get latest 5 courses
  Future<List<CoursesModel>> getSuggestedCourses({int limit = 5}) async {
    final snapshot = await _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return CoursesModel.fromJson(data);
    }).toList();
  }
}
