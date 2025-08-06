import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_cubit.dart';
import 'package:test/features/teacher/home/presentation/widgets/teacher_card_home_teacher.dart';

class TeacherListHomeTeacher extends StatelessWidget {
  const TeacherListHomeTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherCardsCubit>(
      create: (_) => sl<TeacherCardsCubit>()..getTeachers(),
      child: BlocBuilder<TeacherCardsCubit, List<UserModel>>(
        builder: (context, teacher) {
          if (teacher.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return SizedBox(
            height: 100.h,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                width: 10.w,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: teacher.length,
              itemBuilder: (context, index) {
                return TeacherCardHomeTeacher(teacher: teacher[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
