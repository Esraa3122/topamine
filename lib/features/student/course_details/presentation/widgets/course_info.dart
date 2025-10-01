import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class CourseInfo extends StatelessWidget {
  const CourseInfo({
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
        Icon(icon, color: context.color.textColor!.withOpacity(0.7)),
        SizedBox(height: 4.h),
        TextApp(
          text: label,
          theme: context.textStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.bold,
            color: context.color.textColor,
            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
          ),
        ),
        TextApp(
          text: sub,
          theme: context.textStyle.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeightHelper.bold,
            color: context.color.textColor!.withOpacity(0.6),
            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
