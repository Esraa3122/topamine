import 'package:test/features/student/home/data/model/courses_model.dart';

abstract class ViewTeacherProfileState {}

class InitialState extends ViewTeacherProfileState {}

class LoadingState extends ViewTeacherProfileState {}

class LoadedState extends ViewTeacherProfileState {

  LoadedState(this.courses);
  final List<CoursesModel> courses;
}

class ErrorState extends ViewTeacherProfileState {

  ErrorState(this.message);
  final String message;
}
