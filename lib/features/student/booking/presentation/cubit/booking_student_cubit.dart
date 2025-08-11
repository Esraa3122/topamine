import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test/features/student/booking/presentation/cubit/booking_student_state.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class BookingStudentCubit extends Cubit<BookingStudentState> {
  BookingStudentCubit() : super(BookingStudentInitial());

  Future<void> fetchEnrolledCourses() async {
    emit(BookingStudentLoading());
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final now = DateTime.now();

      final enrollmentSnapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('userId', isEqualTo: currentUserId)
          .get();

      final enrolledCourseIds = enrollmentSnapshot.docs
          .map((doc) => doc['courseId'] as String)
          .toList();

      final courseSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .get();

      final courses = courseSnapshot.docs
          .map((doc) => CoursesModel.fromJson({...doc.data(), 'id': doc.id}))
          .where((course) => enrolledCourseIds.contains(course.id))
          .where(
            (course) =>
                course.endDate != null &&
                (now.isBefore(course.endDate!) ||
                    now.isAtSameMomentAs(course.endDate!)),
          )
          .toList();

      emit(BookingStudentLoaded(courses));
    } catch (e) {
      emit(BookingStudentError(e.toString()));
    }
  }
}
