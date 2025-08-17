import 'package:flutter/material.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_card_student.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class CoursesBookingListStudent extends StatelessWidget {

  const CoursesBookingListStudent({
    required this.courses, super.key,
  });
  final List<CoursesModel> courses;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Center(child: Text('لا يوجد كورسات مشترك بها'));
    }

    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return BookingCourseCardStudent(
          course: courses[index],
          showStatus: true,
        );
      },
    );
  }
}


