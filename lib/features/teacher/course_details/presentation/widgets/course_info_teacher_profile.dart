import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class CourseInfoTeacherProfile extends StatelessWidget {
  const CourseInfoTeacherProfile({
    required this.icon,
    required this.label,
    required this.sub,
    super.key,
  });
  final IconData icon;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        SizedBox(height: 4.h),
        TextApp(
          text: label,
          theme: context.textStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.bold,
            color: context.color.textColor,
          ),
        ),
        TextApp(
          text: sub,
          theme: context.textStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeightHelper.bold,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
