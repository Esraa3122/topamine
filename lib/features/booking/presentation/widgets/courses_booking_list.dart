import 'package:flutter/material.dart';
import 'package:test/features/booking/presentation/widgets/course_card.dart';
import 'package:test/features/home/data/model/coures_model.dart';
class CoursesBokkingList extends StatelessWidget {
  final List<CourseModel> courses;

  const CoursesBokkingList({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courses[index], showStatus: true);
      },
    );
  }
}
