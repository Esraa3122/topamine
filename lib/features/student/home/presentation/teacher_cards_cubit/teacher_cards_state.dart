import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

enum TeacherCardsStatus { initial, loading, loaded, loadedCourses, error }

class TeacherCardsState {

  TeacherCardsState({
    this.status = TeacherCardsStatus.initial,
    this.teachers = const [],
    this.courses = const [],
    this.errorMessage,
  });
  final TeacherCardsStatus status;
  final List<UserModel> teachers;
  final List<CoursesModel> courses;
  final String? errorMessage;

  TeacherCardsState copyWith({
    TeacherCardsStatus? status,
    List<UserModel>? teachers,
    List<CoursesModel>? courses,
    String? errorMessage,
  }) {
    return TeacherCardsState(
      status: status ?? this.status,
      teachers: teachers ?? this.teachers,
      courses: courses ?? this.courses,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
