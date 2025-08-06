import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/features/student/bot/presentation/screen/chatbot_screen.dart';
import 'package:test/features/student/home/presentation/refactors/home_student_body.dart';
import 'package:test/features/teacher/add_courses/data/repo/add_course_repository.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';
import 'package:test/features/teacher/add_courses/presentation/screen/add_courses_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: const [
            HomeStudentBody(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.color.bluePinkLight,
        shape: const CircleBorder(),
        onPressed: () {
          //           Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => BlocProvider(
          //       create: (_) => AddCourseCubit(AddCourseRepository()),
          //       child: const AddCourseScreen(),
          //     ),
          //   ),
          // );

          context.pushNamed(AppRoutes.chatBoot);
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
