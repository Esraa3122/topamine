import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class DataSourseSearch {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CoursesModel>> fetchCourses() async {
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) => CoursesModel.fromJson(doc.data())).toList();
  }

  Future<UserModel?> fetchTeacherByName(String name) async {
    final query = await _firestore
        .collection('users')
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      return UserModel.fromJson(query.docs.first.data());
    }
    return null;
  }
}
