import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/course_list.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/custom_shape_profile.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/profile_property.dart';

class ViewProfileTeacherBody extends StatelessWidget {
  const ViewProfileTeacherBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomShapeProfile(
              image: AppImages.logo,
              name: 'Sarah Anderson',
              title: 'Mathematics & Physics Expert',
              properties: [
                ProfileProperty(icon: Icons.mail, text: 'example@gmail.com'),
                ProfileProperty(icon: Icons.phone, text: '+1 (555) 123-4567'),
                ProfileProperty(
                  icon: Icons.location_on_outlined,
                  text: 'New York',
                ),
              ],
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
            CoursesList(),
          ],
        ),
      ),
    );
  }
}
