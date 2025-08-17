import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_state.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class TeacherCardsCubit extends Cubit<TeacherCardsState> {
  TeacherCardsCubit() : super(TeacherCardsState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> getActiveData({bool fetchTeachers = false}) async {
  if (isClosed) return; 
  emit(state.copyWith(status: TeacherCardsStatus.loading));

  try {
    final now = DateTime.now();
    final currentEmail = FirebaseAuth.instance.currentUser?.email;

    final coursesSnapshot = await _firestore.collection('courses').get();

    final activeCourses = <CoursesModel>[];
    final activeTeacherIds = <String>{};

    for (var doc in coursesSnapshot.docs) {
      final course = CoursesModel.fromJson(doc.data());

      if (course.endDate != null &&
          (now.isBefore(course.endDate!) ||
              now.isAtSameMomentAs(course.endDate!))) {
        activeCourses.add(course);
        if (course.teacherId != null) {
          activeTeacherIds.add(course.teacherId!);
        }
      } else {
        await _firestore
            .collection('courses')
            .doc(doc.id)
            .update({'status': 'not active'});
      }
    }

    if (fetchTeachers) {
      if (activeTeacherIds.isEmpty) {
        if (!isClosed) {
          emit(state.copyWith(
              status: TeacherCardsStatus.loaded, teachers: []));
        }
        return;
      }

      final teacherSnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'teacher')
          .where('status', isEqualTo: 'تم القبول')
          .where(FieldPath.documentId, whereIn: activeTeacherIds.toList())
          .get();

      final teachers = teacherSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.userEmail != currentEmail)
          .toList();

      if (!isClosed) {
        emit(state.copyWith(
          status: TeacherCardsStatus.loaded,
          teachers: teachers,
          courses: activeCourses,
        ));
      }
    } else {
      if (!isClosed) {
        emit(state.copyWith(
          status: TeacherCardsStatus.loadedCourses,
          courses: activeCourses,
        ));
      }
    }
  } catch (e) {
    if (!isClosed) {
      emit(state.copyWith(
        status: TeacherCardsStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}

}

