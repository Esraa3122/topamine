import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/student/all_courses/presentation/cubit/all_courses_cubit.dart';
import 'package:test/features/student/home/presentation/widgets/simmer_courses_for_you.dart';
import 'package:test/features/teacher/home/presentation/widgets/contanier_course_home_teacher.dart';

class AllCoursesTeacherProfileBody extends StatelessWidget {
  const AllCoursesTeacherProfileBody({super.key});

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
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          if (state.filteredCourses.isEmpty) {
            return const Center(child: Text('لا توجد كورسات متاحة حاليًا'));
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
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
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
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
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
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      return ContanierCourseHomeTeacher(
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
