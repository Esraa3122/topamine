import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/teacher/all_courses/presentation/refactors/all_courses_teacher_profile_body.dart';

class AllCoursesTeacherProfilePage extends StatefulWidget {
  const AllCoursesTeacherProfilePage({super.key});

  @override
  State<AllCoursesTeacherProfilePage> createState() => _AllCoursesTeacherProfilePageState();
}

class _AllCoursesTeacherProfilePageState extends State<AllCoursesTeacherProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: context.translate(LangKeys.allCourses),
        color: context.color.textColor,
        backgroundColor: context.color.mainColor,
      ),
      body: const AllCoursesTeacherProfileBody(),
    );
  }
}
