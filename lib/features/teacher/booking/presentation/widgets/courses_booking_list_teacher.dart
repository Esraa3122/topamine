import 'package:flutter/material.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';
import 'package:test/features/teacher/booking/presentation/widgets/booking_course_card_teacher.dart';

class CoursesBookingListTeacher extends StatelessWidget {
  const CoursesBookingListTeacher({
    required this.courses,
    required this.selectedFilter,
    required this.searchQuery,
    super.key,
  });
  final List<CoursesModel> courses;
  final String selectedFilter;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return BookingCourseCardTeacher(
          selectedFilter: selectedFilter,
          searchQuery: searchQuery,
        );
      },
    );
  }
}
