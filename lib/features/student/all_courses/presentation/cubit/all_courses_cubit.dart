import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

part 'all_courses_state.dart';

class AllCoursesCubit extends Cubit<AllCoursesState> {
  AllCoursesCubit() : super(AllCoursesState());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void listenToCourses() {
    emit(state.copyWith(status: AllCoursesStatus.loading));

    _firestore.collection('courses').snapshots().listen((snapshot) async {
      final courses = <CoursesModel>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;
        final course = CoursesModel.fromJson(data);

        final now = DateTime.now();
        if (course.endDate != null &&
            (now.isBefore(course.endDate!) ||
                now.isAtSameMomentAs(course.endDate!))) {
          courses.add(course);
        } else {
          await _firestore
              .collection('courses')
              .doc(doc.id)
              .update({'status': 'not active'});
        }
      }

      emit(state.copyWith(
        status: AllCoursesStatus.loaded,
        allCourses: courses,
        filteredCourses: _applyFilter(courses, state.selectedFilter),
        filters: _extractFilters(courses),
      ));
    }, onError: (error) {
      emit(state.copyWith(
        status: AllCoursesStatus.error,
        errorMessage: error.toString(),
      ));
    });
  }

  void changeFilter(String filter) {
    emit(state.copyWith(
      selectedFilter: filter,
      filteredCourses: _applyFilter(state.allCourses, filter),
    ));
  }

  List<CoursesModel> _applyFilter(List<CoursesModel> courses, String filter) {
    if (filter == 'All') return courses;
    return courses
        .where((course) =>
            (course.gradeLevel ?? '').trim().toLowerCase() ==
            filter.trim().toLowerCase())
        .toList();
  }

  List<String> _extractFilters(List<CoursesModel> courses) {
    return <String>{
      'All',
      ...courses
          .where((c) => c.gradeLevel != null && c.gradeLevel!.trim().isNotEmpty)
          .map((c) => c.gradeLevel!.trim()),
    }.toList();
  }
}
