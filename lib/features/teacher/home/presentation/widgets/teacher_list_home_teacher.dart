import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_cubit.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_state.dart';
import 'package:test/features/teacher/home/presentation/widgets/teacher_card_home_teacher.dart';

class TeacherListHomeTeacher extends StatelessWidget {
  const TeacherListHomeTeacher({super.key});

  @override
  Widget build(BuildContext context) {
   return BlocProvider<TeacherCardsCubit>(
      create: (_) => sl<TeacherCardsCubit>()..getActiveData(fetchTeachers: true),
      child: BlocBuilder<TeacherCardsCubit, TeacherCardsState>(
        builder: (context, state) {
          if (state.status == TeacherCardsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == TeacherCardsStatus.loaded) {
            final teachers = state.teachers;
            if (teachers.isEmpty) {
              return const Center(child: Text('لا يوجد مدرسين'));
            }
            return SizedBox(
              height: 100.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: teachers.length,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  return TeacherCardHomeTeacher(teacher: teachers[index]);
                },
              ),
            );
          } else if (state.status == TeacherCardsStatus.error) {
            return Center(child: Text('حدث خطأ: ${state.errorMessage}'));
          } else {
            // initial or other unknown state
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
