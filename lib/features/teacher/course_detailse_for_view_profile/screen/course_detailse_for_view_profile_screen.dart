import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/course_detailse_for_view_profile/refactor/course_detailse_for_view_profile_body.dart';

class CourseDetailseForViewProfileScreen extends StatelessWidget {
  const CourseDetailseForViewProfileScreen({required this.course, super.key});
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
      body: CourseDetailseForViewProfileBody(course: course,)
    );
  }
}