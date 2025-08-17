import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/features/student/booking/presentation/cubit/booking_student_state.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class BookingStudentCubit extends Cubit<BookingStudentState> {
  BookingStudentCubit() : super(BookingStudentInitial());

  void safeEmit(BookingStudentState state) {
    if (!isClosed) emit(state);
  }

  Future<void> fetchEnrolledCourses() async {
    safeEmit(BookingStudentLoading());
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final now = DateTime.now();

      final enrollmentSnapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('userId', isEqualTo: currentUserId)
          .get();

      final Map<String, String> courseStatusMap = {};

      for (var doc in enrollmentSnapshot.docs) {
        final data = doc.data();
        final courseId = data['courseId']?.toString();
        if (courseId == null || courseId.isEmpty) continue;

        final status = data['statusProgress']?.toString() ?? 'inProgress';
        courseStatusMap[courseId] = status;
      }

      final enrolledCourseIds = courseStatusMap.keys.toList();

      final courseSnapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      final courses = courseSnapshot.docs
          .map((doc) {
            final courseId = doc.id;
            if (!enrolledCourseIds.contains(courseId)) return null;

            final courseData = {...doc.data(), 'id': courseId};
            courseData['status'] = courseStatusMap[courseId] ?? 'inProgress';

            final course = CoursesModel.fromJson(courseData);

            if (course.endDate != null &&
                (now.isBefore(course.endDate!) ||
                    now.isAtSameMomentAs(course.endDate!))) {
              return course;
            }
            return null;
          })
          .whereType<CoursesModel>()
          .toList();

      safeEmit(BookingStudentLoaded(courses));
    } catch (e) {
      safeEmit(BookingStudentError(e.toString()));
    }
  }
}
