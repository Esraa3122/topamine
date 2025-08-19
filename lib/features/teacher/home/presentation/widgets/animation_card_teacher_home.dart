import 'package:flutter/material.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/home/presentation/widgets/contanier_course_home_teacher.dart';

class AnimationCardTeacherHome extends StatefulWidget {
  const AnimationCardTeacherHome({required this.course, Key? key}) : super(key: key);
  final CoursesModel course;

  @override
  State<AnimationCardTeacherHome> createState() => _AnimationCardTeacherHomeState();
}

class _AnimationCardTeacherHomeState extends State<AnimationCardTeacherHome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ContanierCourseHomeTeacher(course: widget.course),
      ),
    );
  }
}
