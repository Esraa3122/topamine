import 'package:flutter/material.dart';
import 'package:test/features/student/home/presentation/refactors/home_student_body.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children:const[
          HomeStudentBody(),
        ],
      ),
    );
  }
}
