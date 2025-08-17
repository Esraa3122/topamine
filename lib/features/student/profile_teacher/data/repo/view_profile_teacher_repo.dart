import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class CourseRepository {
  CourseRepository({required this.firestore});
  final FirebaseFirestore firestore;

  Future<List<CoursesModel>> getCoursesByTeacherId(String teacherId) async {
    final now = DateTime.now();

    final snapshot = await firestore
        .collection('courses')
        .where('teacherId', isEqualTo: teacherId)
        // .where('status', isEqualTo: 'active')
        .get();

    return snapshot.docs
        .map((doc) => CoursesModel.fromJson(doc.data()))
        .where((course) =>
            course.endDate != null &&
            (now.isBefore(course.endDate!) ||
             now.isAtSameMomentAs(course.endDate!)))
        .toList();
  }
}
