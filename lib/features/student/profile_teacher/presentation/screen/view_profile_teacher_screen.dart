import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/profile_teacher/presentation/refactors/view_profile_teacher_body.dart';

class ViewProfileTeacherScreen extends StatelessWidget {
  const ViewProfileTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        color: context.color.textColor,
        backgroundColor: context.color.mainColor,
      ),
      body: const ViewProfileTeacherBody(),
    );
  }
}
