import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/student/profile_teacher/data/repo/view_profile_teacher_repo.dart';
import 'package:test/features/student/profile_teacher/presentation/cubit/view_teacher_profile_state.dart';

class ViewTeacherProfileCubit extends Cubit<ViewTeacherProfileState> {
  ViewTeacherProfileCubit(this.repository) : super(InitialState());

  final CourseRepository repository;

  Future<void> fetchCoursesByTeacher(String teacherId) async {
    emit(LoadingState());

    try {
      final courses = await repository.getCoursesByTeacherId(teacherId);
      emit(LoadedState(courses));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }
}

