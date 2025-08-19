import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/profile_teacher/data/repo/view_profile_teacher_repo.dart';
import 'package:test/features/student/profile_teacher/presentation/cubit/view_teacher_profile_cubit.dart';
import 'package:test/features/student/profile_teacher/presentation/cubit/view_teacher_profile_state.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/card_view_teacher.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/card_view_teacher_shimmer.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({required this.teacher, super.key});

  final UserModel teacher;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewTeacherProfileCubit(
        CourseRepository(firestore: FirebaseFirestore.instance),
      )..fetchCoursesByTeacher(teacher.userId),
      child: BlocBuilder<ViewTeacherProfileCubit, ViewTeacherProfileState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (_, __) => const CardViewTeacherShimmer(),
            );
          } else if (state is LoadedState) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.courses.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.courseDetails,
                      arguments: state.courses[index],
                    );
                  },
                  child: CardViewTeacher(course: state.courses[index]),
                );
              },
            );
          } else if (state is ErrorState) {
            return Center(child: Text(state.message));
          }

          return Center(
            child: Lottie.asset(
              AppImages.emptyBox2,
              width: 326.w,
              height: 300.h,
            ),
          );
        },
      ),
    );
  }
}
