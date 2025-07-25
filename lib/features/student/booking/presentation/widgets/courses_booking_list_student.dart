import 'package:flutter/material.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_card_student.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

class CoursesBookingListStudent extends StatelessWidget {
  const CoursesBookingListStudent({required this.courses, super.key});
  final List<CoursesModel> courses;

  @override
  Widget build(BuildContext context) {
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
