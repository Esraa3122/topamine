import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/teacher/add_courses/data/repo/add_course_repository.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';
import 'package:test/features/teacher/add_courses/presentation/screen/add_courses_screen.dart';
import 'package:test/features/teacher/home/presentation/refactors/home_teacher_body.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            HomeTeacherBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.color.bluePinkLight,
        shape: const CircleBorder(),
        onPressed: () {
                    Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AddCourseCubit(AddCourseRepository()),
                child: const AddCourseScreen(),
              ),
            ),
          );

          // context.pushNamed(AppRoutes.chatBoot);
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
