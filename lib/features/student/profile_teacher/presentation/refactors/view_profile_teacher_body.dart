import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/course_list.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/custom_shape_profile.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/follow_button.dart';

class ViewProfileTeacherBody extends StatelessWidget {
  const ViewProfileTeacherBody({
    required this.userModel,
    super.key,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomShapeProfile(
              userModel: userModel,
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: TextApp(
                text: context.translate(LangKeys.myCourses),
                theme: context.textStyle.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: context.color.textColor,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            CoursesList(
              teacher: userModel,
            ),
          ],
        ),
      ),
    );
  }
}
