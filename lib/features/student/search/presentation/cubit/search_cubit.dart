import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/features/student/search/data/data_sourse_search.dart';
import 'package:test/features/student/search/presentation/cubit/search_state.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.firestoreService) : super(const SearchState()) {
    searchController.addListener(_onSearchTextChanged);
    _initialize();
  }
  final DataSourseSearch firestoreService;
  final TextEditingController searchController = TextEditingController();

  void _onSearchTextChanged() {
    final text = searchController.text;
    if (text != state.searchQuery) {
      emit(state.copyWith(searchQuery: text));
    }
  }

  Future<void> _initialize() async {
    await loadRecentSearches();
    await fetchCourses();
  }

  @override
  Future<void> close() {
    searchController
      ..removeListener(_onSearchTextChanged)
      ..dispose();
    return super.close();
  }

  Future<void> fetchCourses() async {
    emit(state.copyWith(isLoading: true));
    try {
      final courses = await firestoreService.fetchCourses();
      final grades = courses
          .map((e) => e.gradeLevel)
          .where((g) => g != null && g.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList();
      final subjects = courses
          .map((e) => e.subject?.trim())
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList();
      final teachers = courses
          .map((e) => e.teacherName)
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList();

      emit(
        state.copyWith(
          allCourses: courses,
          gradeLevelTitles: ['All', ...grades],
          subjectTitles: ['All', ...subjects],
          teacherSuggestions: teachers,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final recents = prefs.getStringList('recentSearches') ?? [];
    emit(state.copyWith(recentSearches: recents));
  }

  Future<void> saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', state.recentSearches);
  }

  void addToRecentSearch(String query) {
    if (query.trim().isEmpty) return;
    final updatedRecents = List<String>.from(state.recentSearches)
    ..remove(query)
    ..insert(0, query);
    if (updatedRecents.length > 5) {
      updatedRecents.removeRange(5, updatedRecents.length);
    }
    emit(state.copyWith(recentSearches: updatedRecents));
    saveRecentSearches();

    if (searchController.text != query) {
      searchController.text = query;
      searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );
    }
  }

  void deleteRecentSearchAt(int index) {
    final updatedRecents = List<String>.from(state.recentSearches)
    ..removeAt(index);
    emit(state.copyWith(recentSearches: updatedRecents));
    saveRecentSearches();
  }

  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void updateSelectedGrade(String grade) {
    emit(state.copyWith(selectedGradeLevel: grade));
  }

  void updateSelectedSubject(String subject) {
    emit(state.copyWith(selectedSubjectName: subject));
  }

  List<CoursesModel> get filteredCourses {
    final lowerSearch = state.searchQuery.toLowerCase().trim();
    final selGradeNorm = state.selectedGradeLevel.toLowerCase().trim();
    final selSubjectNorm = state.selectedSubjectName.toLowerCase().trim();
    final now = DateTime.now();

    return state.allCourses.where((course) {
      final courseTitle = course.title.toLowerCase();
      final courseTeacher = course.teacherName.toLowerCase();
      final courseGrade = (course.gradeLevel ?? '').toLowerCase().trim();
      final courseSubject = (course.subject ?? '').toLowerCase().trim();

      // ignore: avoid_bool_literals_in_conditional_expressions
      final matchSearch = lowerSearch.isEmpty
          ? true
          : (courseTitle.contains(lowerSearch) ||
                courseTeacher.contains(lowerSearch) ||
                courseGrade.contains(lowerSearch) ||
                courseSubject.contains(lowerSearch));

      final matchGradeLevel =
          selGradeNorm == 'all' || courseGrade == selGradeNorm;
      final matchSubject =
          selSubjectNorm == 'all' || courseSubject == selSubjectNorm;

      final courseEndDate = (course.endDate is Timestamp)
          ? (course.endDate! as Timestamp).toDate()
          : course.endDate;
      final notExpired = courseEndDate == null || courseEndDate.isAfter(now);

      return matchSearch && matchGradeLevel && matchSubject && notExpired;
    }).toList();
  }

  List<String> get filteredTeachers {
    final lowerSearch = state.searchQuery.toLowerCase();
    return state.teacherSuggestions
        .where((teacher) => teacher.toLowerCase().contains(lowerSearch))
        .toList();
  }
}
