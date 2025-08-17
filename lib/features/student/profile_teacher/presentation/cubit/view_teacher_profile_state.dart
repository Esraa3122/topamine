import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

abstract class ViewTeacherProfileState {}

class InitialState extends ViewTeacherProfileState {}

class LoadingState extends ViewTeacherProfileState {}

class LoadedState extends ViewTeacherProfileState {
  final List<CoursesModel> courses;

  LoadedState(this.courses);
}

class ErrorState extends ViewTeacherProfileState {
  final String message;

  ErrorState(this.message);
}
