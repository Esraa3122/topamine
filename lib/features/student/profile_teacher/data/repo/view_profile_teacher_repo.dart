import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class CourseRepository {

  CourseRepository({required this.firestore});
  final FirebaseFirestore firestore;

  Future<List<CoursesModel>> getCoursesByTeacherId(String teacherId) async {
    final snapshot = await firestore
        .collection('courses')
        .where('teacherEmail', isEqualTo: teacherId)
        .get();

    return snapshot.docs
        .map((doc) => CoursesModel.fromJson(doc.data()))
        .toList();
  }
}
