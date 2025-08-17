import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
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
          context.pushNamed(AppRoutes.chatBoot);
        },
        child: const Icon(Icons.chat, color: Colors.white),
      ),
    );
  }
}
