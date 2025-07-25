import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
<<<<<<< HEAD
import 'package:test/core/di/injection_container.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/home/presentation/cubit/teacher_cards_cubit.dart';
import 'package:test/features/student/home/presentation/widgets/teacher_card_home.dart';

class TeachersList extends StatelessWidget {
  const TeachersList({super.key});

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
                return TeacherCard(teacher: teacher[index]);
              },
            ),
=======
import 'package:test/features/student/home/data/model/teacher_model_home.dart';
import 'package:test/features/student/home/data/user_service.dart';
import 'package:test/features/student/home/presentation/widgets/teacher_card_home.dart';

class TeachersList extends StatefulWidget {
  const TeachersList({super.key});

  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  late Future<List<TeacherModel>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = UserService().getTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: FutureBuilder<List<TeacherModel>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('error throw display teacher'));
          }
          final teachers = snapshot.data ?? [];
          if (teachers.isEmpty) {
            return const Center(child: Text('No Teacher Now'));
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: teachers.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              return TeacherCard(teacher: teachers[index]);
            },
>>>>>>> ahmed
          );
        },
      ),
    );
  }
}
