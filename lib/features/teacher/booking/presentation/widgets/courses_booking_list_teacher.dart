import 'package:flutter/material.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
import 'package:test/features/teacher/booking/presentation/widgets/booking_course_card_teacher.dart';

class CoursesBookingListTeacher extends StatelessWidget {
  const CoursesBookingListTeacher({required this.courses, super.key});
  final List<CourseModel> courses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return BookingCourseCardTeacher(
          course: courses[index],
          showStatus: true,
        );
      },
    );
  }
}
