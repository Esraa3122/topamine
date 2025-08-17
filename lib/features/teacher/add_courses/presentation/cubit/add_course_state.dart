part of 'add_course_cubit.dart';

abstract class AddCourseState {}

class AddCourseInitial extends AddCourseState {}

class AddCourseLoading extends AddCourseState {}

class AddCourseLectureAdded extends AddCourseState {
  AddCourseLectureAdded(this.totalLectures);
  final int totalLectures;
}


class AddCourseSuccess extends AddCourseState {}

class AddCourseError extends AddCourseState {
  AddCourseError(this.message);
  final String message;
}
