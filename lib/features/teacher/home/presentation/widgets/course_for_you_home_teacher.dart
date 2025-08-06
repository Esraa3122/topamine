import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/student/all_courses/data/course_service.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/home/presentation/widgets/contanier_course_home_teacher.dart';

class CourseForYouHomeTeacher extends StatefulWidget {
  const CourseForYouHomeTeacher({super.key});

  @override
  State<CourseForYouHomeTeacher> createState() => _CourseForYouHomeTeacherState();
}

class _CourseForYouHomeTeacherState extends State<CourseForYouHomeTeacher> {
  late Future<List<CoursesModel>> _suggestedCoursesFuture;

  @override
  void initState() {
    super.initState();
    _suggestedCoursesFuture = CourseService().getSuggestedCourses();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: FutureBuilder<List<CoursesModel>>(
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
              return ContanierCourseHomeTeacher(course: courses[index]);
            },
          );
        },
      ),
    );
  }
}
