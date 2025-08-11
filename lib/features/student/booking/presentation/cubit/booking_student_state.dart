import 'package:equatable/equatable.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

abstract class BookingStudentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingStudentInitial extends BookingStudentState {}

class BookingStudentLoading extends BookingStudentState {}

class BookingStudentLoaded extends BookingStudentState {
  BookingStudentLoaded(this.courses);
  final List<CoursesModel> courses;

  @override
  List<Object?> get props => [courses];
}

class BookingStudentError extends BookingStudentState {
  BookingStudentError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
