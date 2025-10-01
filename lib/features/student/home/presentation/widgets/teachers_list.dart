import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/features/student/home/presentation/teacher_cards_cubit/teacher_cards_cubit.dart';
import 'package:test/features/student/home/presentation/teacher_cards_cubit/teacher_cards_state.dart';
import 'package:test/features/student/home/presentation/widgets/simmer_teacher_card.dart';
import 'package:test/features/student/home/presentation/widgets/teacher_card_home.dart';

class TeachersList extends StatelessWidget {
  const TeachersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TeacherCardsCubit>(
      create: (_) =>
          sl<TeacherCardsCubit>()..getActiveData(fetchTeachers: true),
      child: BlocBuilder<TeacherCardsCubit, TeacherCardsState>(
        builder: (context, state) {
          if (state.status == TeacherCardsStatus.loading) {
            return SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemBuilder: (context, index) => const TeacherCardShimmer(),
              ),
            );
          } else if (state.status == TeacherCardsStatus.loaded) {
            final teachers = state.teachers;
            if (teachers.isEmpty) {
              return const Center(
                child: TextApp(
                  text: 'لا يوجد مدرسين',
                  theme: TextStyle(
                    letterSpacing: 0.5,
                    fontFamily: FontFamilyHelper.cairoArabic,
                  ),
                ),
              );
            }
            return SizedBox(
              height: 125.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: teachers.length,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  return TeacherCard(teacher: teachers[index]);
                },
              ),
            );
          } else if (state.status == TeacherCardsStatus.error) {
            return Center(
              child: TextApp(
                text: 'حدث خطأ: ${state.errorMessage}',
                theme: const TextStyle(
                  letterSpacing: 0.5,
                  fontFamily: FontFamilyHelper.cairoArabic,
                ),
              ),
            );
          } else {
            // initial or other unknown state
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
