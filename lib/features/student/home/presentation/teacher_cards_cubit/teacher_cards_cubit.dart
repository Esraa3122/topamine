import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/home/presentation/teacher_cards_cubit/teacher_cards_state.dart';
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
          await _firestore.collection('courses').doc(doc.id).update({
            'status': 'not active',
          });
        }
      }

      activeCourses.sort((a, b) {
        final aDate = a.createdAt ?? DateTime(1900);
        final bDate = b.createdAt ?? DateTime(1900);
        return bDate.compareTo(aDate);
      });

      final latestFiveCourses = activeCourses.length > 5
          ? activeCourses.sublist(0, 5)
          : activeCourses;

      if (fetchTeachers) {
        if (activeTeacherIds.isEmpty) {
          if (!isClosed) {
            emit(
              state.copyWith(status: TeacherCardsStatus.loaded, teachers: []),
            );
          }
          return;
        }

        final teacherSnapshot = await _firestore
            .collection('users')
            .where('role', isEqualTo: 'teacher')
            .where('status', isEqualTo: 'تم القبول')
            .where(FieldPath.documentId, whereIn: activeTeacherIds.toList())
            .get();

        var teachers = teacherSnapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .where((user) => user.userEmail != currentEmail)
            .toList();

        // 🟢 احسب التقييم لكل مدرس
        final teacherRatings = <String, double>{};
        for (var teacher in teachers) {
          final courses = await _firestore
              .collection('courses')
              .where('teacherId', isEqualTo: teacher.userId)
              .get();

          var totalRating = 0.0;
          var totalCount = 0;

          for (var courseDoc in courses.docs) {
            final ratingsSnapshot = await courseDoc.reference
                .collection('ratings')
                .get();

            for (final ratingDoc in ratingsSnapshot.docs) {
              final ratingRaw = ratingDoc['rating'];
              final ratingNum = ratingRaw is num
                  ? ratingRaw.toDouble()
                  : double.tryParse(ratingRaw.toString()) ?? 0.0;

              totalRating += ratingNum;
              totalCount++;
            }
          }

          final avg = totalCount == 0 ? 0.0 : totalRating / totalCount;
          teacherRatings[teacher.userId] = avg;
        }

        // 🟢 رتب المدرسين حسب التقييم (أعلى للأقل)
        teachers.sort((a, b) {
          final ratingA = teacherRatings[a.userId] ?? 0.0;
          final ratingB = teacherRatings[b.userId] ?? 0.0;
          return ratingB.compareTo(ratingA);
        });

        if (!isClosed) {
          emit(
            state.copyWith(
              status: TeacherCardsStatus.loaded,
              teachers: teachers,
              courses: latestFiveCourses,
            ),
          );
        }
      } else {
        if (!isClosed) {
          emit(
            state.copyWith(
              status: TeacherCardsStatus.loadedCourses,
              courses: latestFiveCourses,
            ),
          );
        }
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: TeacherCardsStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }
}
