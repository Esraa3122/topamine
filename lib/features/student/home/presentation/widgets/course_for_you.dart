import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
import 'package:test/features/student/home/presentation/widgets/contanier_course.dart';
class CoursesListYou extends StatelessWidget {
  CoursesListYou({super.key});

  final List<CourseModel> courses = [
    CourseModel(
      image: AppImages.logo,
      title: 'Advanced Mathematics',
      teacher: 'Dr. James Wilson',
      enrolledDate: 'Sept 15, 2023',
      status: 'Completed 80%',
      subject: 'Mathematics',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'AP Physics',
      teacher: 'Prof. Emily Chen',
      enrolledDate: 'Aug 30, 2023',
      status: 'Completed 50%',
      subject: 'Physics',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'SAT Preparation',
      teacher: 'Mr. Robert Brown',
      enrolledDate: 'July 10, 2023',
      status: 'Completed 30%',
      subject: 'Preparation',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 10.w,),
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ContanierCourse(course: courses[index]);
        },
      ),
    );
  }
}
