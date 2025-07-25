import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/profile_teacher/data/repo/view_profile_teacher_repo.dart';
import 'package:test/features/student/profile_teacher/presentation/cubit/view_teacher_profile_cubit.dart';
import 'package:test/features/student/profile_teacher/presentation/cubit/view_teacher_profile_state.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/card_view_teacher.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({required this.teacher, super.key});

  final UserModel teacher;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewTeacherProfileCubit(
        CourseRepository(firestore: FirebaseFirestore.instance),
      )..fetchCoursesByTeacher(teacher.userEmail),
      child: BlocBuilder<ViewTeacherProfileCubit, ViewTeacherProfileState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LoadedState) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                return CardViewTeacher(course: state.courses[index]);
              },
            );
          }

          if (state is ErrorState) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text('No courses available.'));
        },
      ),
    );
  }
}
