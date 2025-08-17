import 'package:flutter/material.dart';
import 'package:test/features/teacher/booking/presentation/widgets/booking_course_card_teacher.dart';

class CoursesBookingListTeacher extends StatelessWidget {
  const CoursesBookingListTeacher({
    required this.selectedFilter,
    required this.searchQuery,
    super.key,
  });
  final String selectedFilter;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return BookingCourseCardTeacher(
      selectedFilter: selectedFilter,
      searchQuery: searchQuery,
    );
  }
}
