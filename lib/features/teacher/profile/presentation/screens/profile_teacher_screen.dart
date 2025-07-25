import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/teacher/profile/presentation/refactors/profile_teacher_body.dart';

class ProfileTeacherScreen extends StatefulWidget {
  const ProfileTeacherScreen({super.key });

  @override
  State<ProfileTeacherScreen> createState() => _ProfileTeacherScreenState();
}

class _ProfileTeacherScreenState extends State<ProfileTeacherScreen> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          // border: Border.all(color: context.color.mainColor!),
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: [
              context.color.mainColor!.withOpacity(0.8),
              Colors.grey.withOpacity(0.8),
            ],
            begin: const Alignment(0.36, 0.27),
            end: const Alignment(0.58, 0.85),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 2,
            ),
            BoxShadow(
              color: context.color.containerShadow2!.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 2,
            ),
          ],
        ),
        child: const ProfileTeacherBody(),
      ),
    );
  }
}
