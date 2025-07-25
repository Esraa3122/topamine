import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';
=======
import 'package:test/features/student/all_courses/data/course_service.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
>>>>>>> ahmed
import 'package:test/features/student/home/presentation/widgets/contanier_course.dart';

<<<<<<< HEAD
  final List<CoursesModel> courses = [
    CoursesModel(
      imageUrl: AppImages.logo,
      title: 'Advanced Mathematics',
      teacherName: 'Dr. James Wilson',
      enrolledDate: 'Sept 15, 2023',
      status: 'Completed 80%',
      subject: 'Mathematics',
    ),
    CoursesModel(
      imageUrl: AppImages.logo,
      title: 'AP Physics',
      teacherName: 'Prof. Emily Chen',
      enrolledDate: 'Aug 30, 2023',
      status: 'Completed 50%',
      subject: 'Physics',
    ),
    CoursesModel(
      imageUrl: AppImages.logo,
      title: 'SAT Preparation',
      teacherName: 'Mr. Robert Brown',
      enrolledDate: 'July 10, 2023',
      status: 'Completed 30%',
      subject: 'Preparation',
    ),
  ];
=======
class CoursesListYou extends StatefulWidget {
  const CoursesListYou({super.key});

  @override
  State<CoursesListYou> createState() => _CoursesListYouState();
}

class _CoursesListYouState extends State<CoursesListYou> {
  late Future<List<CourseModel>> _suggestedCoursesFuture;

  @override
  void initState() {
    super.initState();
    _suggestedCoursesFuture = CourseService().getSuggestedCourses();
  }
>>>>>>> ahmed

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: FutureBuilder<List<CourseModel>>(
        future: _suggestedCoursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final courses = snapshot.data ?? [];

          if (courses.isEmpty) {
            return const Center(
              child: Text(
                'No courses available.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return ContanierCourse(course: courses[index]);
            },
          );
        },
      ),
    );
  }
}
