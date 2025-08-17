import 'package:equatable/equatable.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final List<CoursesModel> allCourses;
  final List<String> gradeLevelTitles;
  final List<String> subjectTitles;
  final List<String> teacherSuggestions;
  final List<String> recentSearches;
  final String selectedGradeLevel;
  final String selectedSubjectName;
  final String searchQuery;

  const SearchState({
    this.isLoading = true,
    this.allCourses = const [],
    this.gradeLevelTitles = const ['All'],
    this.subjectTitles = const ['All'],
    this.teacherSuggestions = const [],
    this.recentSearches = const [],
    this.selectedGradeLevel = 'All',
    this.selectedSubjectName = 'All',
    this.searchQuery = '',
  });

  SearchState copyWith({
    bool? isLoading,
    List<CoursesModel>? allCourses,
    List<String>? gradeLevelTitles,
    List<String>? subjectTitles,
    List<String>? teacherSuggestions,
    List<String>? recentSearches,
    String? selectedGradeLevel,
    String? selectedSubjectName,
    String? searchQuery,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      allCourses: allCourses ?? this.allCourses,
      gradeLevelTitles: gradeLevelTitles ?? this.gradeLevelTitles,
      subjectTitles: subjectTitles ?? this.subjectTitles,
      teacherSuggestions: teacherSuggestions ?? this.teacherSuggestions,
      recentSearches: recentSearches ?? this.recentSearches,
      selectedGradeLevel: selectedGradeLevel ?? this.selectedGradeLevel,
      selectedSubjectName: selectedSubjectName ?? this.selectedSubjectName,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        allCourses,
        gradeLevelTitles,
        subjectTitles,
        teacherSuggestions,
        recentSearches,
        selectedGradeLevel,
        selectedSubjectName,
        searchQuery,
      ];
}
