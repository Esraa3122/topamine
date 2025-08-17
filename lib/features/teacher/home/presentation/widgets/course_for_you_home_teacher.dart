import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/features/student/all_courses/data/course_service.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_cubit.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_state.dart';
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
      child: BlocProvider(
      create: (_) => sl<TeacherCardsCubit>()..getActiveData(),
      child: SizedBox(
        height: 200.h,
        child: BlocBuilder<TeacherCardsCubit, TeacherCardsState>(
          builder: (context, state) {
            if (state.status == TeacherCardsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == TeacherCardsStatus.error) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }

            final courses = state.courses;

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
      ),
    ),);
  }
}
