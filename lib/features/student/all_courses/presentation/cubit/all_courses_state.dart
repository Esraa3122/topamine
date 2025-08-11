part of 'all_courses_cubit.dart';

enum AllCoursesStatus { initial, loading, loaded, error }

class AllCoursesState {
  final AllCoursesStatus status;
  final List<CoursesModel> allCourses;
  final List<CoursesModel> filteredCourses;
  final List<String> filters;
  final String selectedFilter;
  final String errorMessage;

  const AllCoursesState({
    this.status = AllCoursesStatus.initial,
    this.allCourses = const [],
    this.filteredCourses = const [],
    this.filters = const ['All'],
    this.selectedFilter = 'All',
    this.errorMessage = '',
  });

  AllCoursesState copyWith({
    AllCoursesStatus? status,
    List<CoursesModel>? allCourses,
    List<CoursesModel>? filteredCourses,
    List<String>? filters,
    String? selectedFilter,
    String? errorMessage,
  }) {
    return AllCoursesState(
      status: status ?? this.status,
      allCourses: allCourses ?? List.from(this.allCourses),
      filteredCourses: filteredCourses ?? List.from(this.filteredCourses),
      filters: filters ?? List.from(this.filters),
      selectedFilter: selectedFilter ?? this.selectedFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
