import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/data/repo/add_course_repository.dart';
import 'package:test/features/teacher/edit_courses/cubit/edit_course_cubit.dart';
import 'package:test/features/teacher/edit_courses/refactor/edit_courses_teacher_body.dart';

class EditCoursesTeacherScreen extends StatelessWidget {
  const EditCoursesTeacherScreen({
    required this.coursesModel,
    super.key,
  });

  final CoursesModel coursesModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditCourseCubit(AddCourseRepository()),
      child: EditCoursesTeacherBody(coursesModel: coursesModel),
    );
  }
}
