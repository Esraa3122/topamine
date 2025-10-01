import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/all_courses/presentation/cubit/all_courses_cubit.dart';
import 'package:test/features/student/home/presentation/widgets/animated_card.dart';
import 'package:test/features/student/home/presentation/widgets/simmer_courses_for_you.dart';

class AllCoursesBody extends StatelessWidget {
  const AllCoursesBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AllCoursesCubit()..listenToCourses(),
      child: BlocBuilder<AllCoursesCubit, AllCoursesState>(
        builder: (context, state) {
          if (state.status == AllCoursesStatus.loading) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) => const CourseCardShimmer(),
              ),
            );
          }

          if (state.status == AllCoursesStatus.error) {
            return Center(child: TextApp(
              text: 'Error: ${state.errorMessage}', 
              theme: TextStyle(
                fontFamily: FontFamilyHelper.cairoArabic,
                fontSize: 18.sp,
                letterSpacing: 0.5
              ),));
          }

          if (state.filteredCourses.isEmpty) {
            return Center(
              child: Lottie.asset(
                AppImages.emptyBox2,
                width: 326.w,
                height: 300.h,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.filters.length,
                    separatorBuilder: (_, _) => SizedBox(width: 10.w),
                    itemBuilder: (context, index) {
                      final filter = state.filters[index];
                      final isSelected = filter == state.selectedFilter;
                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<AllCoursesCubit>().changeFilter(filter);
                        },
                        selectedColor: Colors.blueAccent,
                        backgroundColor: Colors.grey.shade200,
                        shape: const StadiumBorder(),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontFamily: FontFamilyHelper.cairoArabic,
                          letterSpacing: 0.5
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: GridView.builder(
                    itemCount: state.filteredCourses.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 0.65,
                        ),
                    itemBuilder: (context, index) {
                      return AnimatedCourseCard(
                        course: state.filteredCourses[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
