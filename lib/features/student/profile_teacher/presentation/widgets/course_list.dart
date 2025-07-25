import 'package:flutter/material.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_card_student.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';

class CoursesList extends StatelessWidget {
  CoursesList({super.key});

  final List<CourseModel> courses = [
    // CourseModel(
    //   image: AppImages.logo,
    //   title: 'Advanced Mathematics',
    //   teacher: 'Dr. James Wilson',
    //   enrolledDate: 'Sept 15, 2023',
    //   status: 'inprogress',
    // ),
    // CourseModel(
    //   image: AppImages.logo,
    //   title: 'AP Physics',
    //   teacher: 'Prof. Emily Chen',
    //   enrolledDate: 'Aug 30, 2023',
    //   status: 'complated',
    // ),
    // CourseModel(
    //   image: AppImages.logo,
    //   title: 'SAT Preparation',
    //   teacher: 'Mr. Robert Brown',
    //   enrolledDate: 'July 10, 2023',
    //   status: 'complated',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return BookingCourseCardStudent(course: courses[index]);
      },
    );
  }
}
