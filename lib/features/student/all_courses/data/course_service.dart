import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // all courses
  Future<List<CoursesModel>> getAllCourses() async {
    final snapshot = await _firestore.collection('courses').get();

    return snapshot.docs.map((doc) {
      return CoursesModel.fromJson(doc.data(), );
    }).toList();
  }

  // some courses tpo 5
  Future<List<CoursesModel>> getSuggestedCourses({int limit = 5}) async {
    final snapshot = await _firestore
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs.map((doc) {
      return CoursesModel.fromJson(doc.data(), );
    }).toList();
  }
  
}
