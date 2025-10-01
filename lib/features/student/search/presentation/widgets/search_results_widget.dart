import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/loading/empty_screen.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/features/student/search/presentation/widgets/card_search.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    required this.teachers,
    required this.courses,
    required this.onTeacherSelected,
    required this.onCourseSelected,
    super.key,
  });
  final List<String> teachers;
  final List<CoursesModel> courses;
  // ignore: inference_failure_on_function_return_type
  final Function(String) onTeacherSelected;
  // ignore: inference_failure_on_function_return_type
  final Function(CoursesModel) onCourseSelected;

  @override
  Widget build(BuildContext context) {
    List<Widget> results = [];

    for (var teacher in teachers) {
      results.add(
        ListTile(
          leading: const Icon(Icons.person),
          title: TextApp(
            text: teacher,
            theme: context.textStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: context.color.textColor,
              fontSize: 15.sp,
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5,
            ),
          ),
          onTap: () => onTeacherSelected(teacher),
        ),
      );
    }

    if (teachers.isEmpty && courses.isEmpty) {
      results.add(const EmptyScreen());
    } else {
      for (var course in courses) {
        results.add(
          InkWell(
            onTap: () => onCourseSelected(course),
            child: CardSearch(course: course),
          ),
        );
      }
    }

    return ListView(children: results);
  }
}
