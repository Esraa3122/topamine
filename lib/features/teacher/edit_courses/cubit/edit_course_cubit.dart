import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/data/repo/add_course_repository.dart';

part 'edit_course_state.dart';

class EditCourseCubit extends Cubit<EditCourseState> {
  EditCourseCubit(this.repository) : super(EditCourseInitial());

  final AddCourseRepository repository;
  List<LectureModel> lectures = [];

  Future<void> uploadLecture({
    required String title,
    required File video,
    File? word,
    File? text,
  }) async {
    emit(EditCourseLoading());

    final videoUrl = await repository.uploadLectureFile(video, 'video');
    final wordUrl = word != null
        ? await repository.uploadLectureFile(word, 'raw')
        : null;
    final textUrl = text != null
        ? await repository.uploadLectureFile(text, 'raw')
        : null;

    if (videoUrl == null) {
      emit(EditCourseError('Video upload failed'));
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

    emit(EditCourseLectureAdded(lectures.length));
  }

  Future<void> updateCourse({
    required CoursesModel course,
    File? imageFile,
  }) async {
    emit(EditCourseLoading());
    try {
      await repository.updateCourse(
        course: course,
        imageFile: imageFile,
        newLectures: lectures.isNotEmpty ? lectures : null,
      );
      emit(EditCourseSuccess());
      lectures = [];
    } catch (e) {
      emit(EditCourseError(e.toString()));
    }
  }
}
