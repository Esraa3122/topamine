import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/home/presentation/teacher_cards_cubit/teacher_cards_cubit.dart';
import 'package:test/features/student/home/presentation/teacher_cards_cubit/teacher_cards_state.dart';
import 'package:test/features/student/home/presentation/widgets/animated_card.dart';
import 'package:test/features/student/home/presentation/widgets/simmer_courses_for_you.dart';

class CoursesListYou extends StatelessWidget {
  const CoursesListYou({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TeacherCardsCubit>()..getActiveData(),
      child: SizedBox(
        height: 280.h,
        child: BlocBuilder<TeacherCardsCubit, TeacherCardsState>(
          builder: (context, state) {
            if (state.status == TeacherCardsStatus.loading) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemCount: 4,
                itemBuilder: (context, index) => const CourseCardShimmer(),
              );
            }

            if (state.status == TeacherCardsStatus.error) {
              return Center(
                child: TextApp(
                  text: 'Error: ${state.errorMessage}',
                  theme: const TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: FontFamilyHelper.cairoArabic,
                  ),
                ),
              );
            }

            final courses = state.courses;

            if (courses.isEmpty) {
              return Center(
                child: TextApp(
                  text: 'No courses available.',
                  theme: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.regular,
                    letterSpacing: 0.5,
                    fontFamily: FontFamilyHelper.cairoArabic,
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(width: 10.w),
              itemCount: courses.length,
              itemBuilder: (context, index) => SizedBox(
                width: 200.w,
                child: AnimatedCourseCard(course: courses[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
