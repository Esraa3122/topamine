import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/course_details/presentation/refactors/course_details_teacher_profile_body.dart';

class CourseDetailsTeacherProfileScreen extends StatelessWidget {
  const CourseDetailsTeacherProfileScreen({required this.course, super.key});
    final CoursesModel course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.mainColor,
      appBar: CustomAppBar(
        title: context.translate(LangKeys.courseDetails),
        color: context.color.textColor,
        backgroundColor: context.color.mainColor,
      ),
      body: CourseDetailsTeacherProfileBody(course: course,)
    );
  }
}
