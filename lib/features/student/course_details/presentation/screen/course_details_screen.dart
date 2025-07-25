import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/student/course_details/presentation/refactors/course_details_body.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({required this.course, super.key});
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
      body: CourseDetailsBody(course: course,)
    );
  }
}
