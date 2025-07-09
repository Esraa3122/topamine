import 'package:flutter/material.dart';
import 'package:test/features/teacher/profile/presentation/refactors/profile_teacher_body.dart';

class ProfileTeacherScreen extends StatelessWidget {
  const ProfileTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const ProfileTeacherBody(),
    );
  }
}
