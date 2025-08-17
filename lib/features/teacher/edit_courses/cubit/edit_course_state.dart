part of 'edit_course_cubit.dart';

abstract class EditCourseState {}

class EditCourseInitial extends EditCourseState {}

class EditCourseLoading extends EditCourseState {}

class EditCourseSuccess extends EditCourseState {}

class EditCourseError extends EditCourseState {
  final String message;
  EditCourseError(this.message);
}

class EditCourseLectureAdded extends EditCourseState {
  final int lecturesCount;
  EditCourseLectureAdded(this.lecturesCount);
}

