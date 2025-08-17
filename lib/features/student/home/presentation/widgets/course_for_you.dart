import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_cubit.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_state.dart';
import 'package:test/features/student/home/presentation/widgets/contanier_course.dart';

class CoursesListYou extends StatelessWidget {
  const CoursesListYou({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
                return ContanierCourse(course: courses[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
