import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/profile_teacher/presentation/screen/view_profile_teacher_screen.dart';
import 'package:test/features/student/search/data/data_sourse_search.dart';
import 'package:test/features/student/search/presentation/cubit/search_cubit.dart';
import 'package:test/features/student/search/presentation/cubit/search_state.dart';
import 'package:test/features/student/search/presentation/widgets/custom_text_search.dart';
import 'package:test/features/student/search/presentation/widgets/filters_widget.dart';
import 'package:test/features/student/search/presentation/widgets/recent_searches_widget.dart';
import 'package:test/features/student/search/presentation/widgets/search_results_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(DataSourseSearch()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: SpinKitSpinningLines(
              color: context.color.textColor!,
              size: 50.sp,
            ),
          );
        }

        final filteredCourses = cubit.filteredCourses;
        final filteredTeachers = cubit.filteredTeachers;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFadeInLeft(
                duration: 800,
                child: CustomTextSearch(
                  searchController: cubit.searchController,
                  onSubmitted: cubit.addToRecentSearch,
                ),
              ),
              SizedBox(height: 20.h),
              FiltersWidget(
                gradeLevels: state.gradeLevelTitles,
                subjects: state.subjectTitles,
                selectedGrade: state.selectedGradeLevel,
                selectedSubject: state.selectedSubjectName,
                onGradeSelected: cubit.updateSelectedGrade,
                onSubjectSelected: cubit.updateSelectedSubject,
              ),
              SizedBox(height: 20.h),
              TextApp(
                text: context.translate(LangKeys.lastsearch),
                theme: context.textStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: context.color.textColor,
                ),
              ),
              SizedBox(height: 15.h),
              Expanded(
                child:
                    (state.searchQuery.trim().isNotEmpty ||
                        state.selectedGradeLevel != 'All' ||
                        state.selectedSubjectName != 'All')
                    ? SearchResultsWidget(
                        teachers: filteredTeachers,
                        courses: filteredCourses,
                        onTeacherSelected: (teacher) async {
                          cubit.addToRecentSearch(teacher);
                          final teacherModel = await cubit.firestoreService
                              .fetchTeacherByName(teacher);
                          if (teacherModel != null) {
                            if (!context.mounted) return;
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewProfileTeacherScreen(
                                  userModel: teacherModel,
                                ),
                              ),
                            );
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Teacher not found'),
                              ),
                            );
                          }
                        },
                        onCourseSelected: (course) {
                          cubit.addToRecentSearch(course.title);
                          if (!context.mounted) return;
                          Navigator.pushNamed(
                            context,
                            AppRoutes.courseDetails,
                            arguments: course,
                          );
                        },
                      )
                    : RecentSearchesWidget(
                        recentSearches: state.recentSearches,
                        onSearchTap: cubit.updateSearchQuery,
                        onDeleteTap: cubit.deleteRecentSearchAt,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
