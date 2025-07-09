import 'package:flutter/material.dart';
import 'package:test/features/booking/presentation/widgets/course_card.dart';
import 'package:test/features/home/data/model/coures_model.dart';
class CoursesList extends StatelessWidget {
  
  CoursesList({super.key});

  final List<CourseModel> courses = [
    CourseModel(
      image: 'assets/images/Mathematics-Hero-1600x900.jpg',
      title: 'Advanced Mathematics',
      teacher: 'Dr. James Wilson',
      enrolledDate: 'Sept 15, 2023',
      status: 'inprogress',
    ),
    CourseModel(
      image: 'assets/images/Mathematics-Hero-1600x900.jpg',
      title: 'AP Physics',
      teacher: 'Prof. Emily Chen',
      enrolledDate: 'Aug 30, 2023',
      status: 'complated',
    ),
    CourseModel(
      image: 'assets/images/Mathematics-Hero-1600x900.jpg',
      title: 'SAT Preparation',
      teacher: 'Mr. Robert Brown',
      enrolledDate: 'July 10, 2023',
      status: 'complated',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        return CourseCard(course: courses[index]);
      },
    );
  }
}
