import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/features/student/home/data/model/teacher_model_home.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TeacherModel>> getTeachers() async {
    final snapshot = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'teacher')
        .get();

    return snapshot.docs.map((doc) {
      return TeacherModel.fromJson(doc.data(), doc.id);
    }).toList();
  }
}
