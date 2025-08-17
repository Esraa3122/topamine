import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/data/repo/add_course_repository.dart';

part 'add_course_state.dart';

class AddCourseCubit extends Cubit<AddCourseState> {

  AddCourseCubit(this.repository) : super(AddCourseInitial());
  final AddCourseRepository repository;

  List<LectureModel> lectures = [];

  Future<void> uploadLecture({
    required String title,
    required File video,
    File? word,
    File? text,
  }) async {
    emit(AddCourseLoading());

    final videoUrl = await repository.uploadLectureFile(video, 'video');
    final wordUrl = word != null
        ? await repository.uploadLectureFile(word, 'raw')
        : null;
    final textUrl = text != null
        ? await repository.uploadLectureFile(text, 'raw')
        : null;

    if (videoUrl == null) {
      emit(AddCourseError('Video upload failed'));
      return;
    }

    lectures.add(
      LectureModel(
        title: title,
        videoUrl: videoUrl,
        docUrl: wordUrl,
        txtUrl: textUrl,
      ),
    );

    emit(AddCourseLectureAdded(lectures.length));
  }

  Future<void> submitCourse({
    required CoursesModel course,
    required File imageFile,
  }) async {
    emit(AddCourseLoading());

    try {
      await repository.addCourse(
        course: course.copyWith(lectures: lectures),
        imageFile: imageFile,
      );
      emit(AddCourseSuccess());
      lectures = [];
    } catch (e) {
      emit(AddCourseError(e.toString()));
    }
  }
  
  Future<void> updateCourse({
    required CoursesModel course,
    File? imageFile,
  }) async {
    emit(AddCourseLoading());
    try {
      await repository.updateCourse(
        course: course,
        imageFile: imageFile,
        newLectures: lectures.isNotEmpty ? lectures : null,
      );
      emit(AddCourseSuccess());
      lectures = [];
    } catch (e) {
      emit(AddCourseError(e.toString()));
    }
  }
}