import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_card_student.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class CoursesBookingListStudent extends StatelessWidget {
  const CoursesBookingListStudent({
    required this.courses,
    super.key,
  });
  final List<CoursesModel> courses;

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Center(
        child: Lottie.asset(AppImages.emptyBox2, width: 326.w, height: 300.h),
      );
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
