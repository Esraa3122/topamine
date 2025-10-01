import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';

class CustomContanierCourse extends StatelessWidget {
  const CustomContanierCourse({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    super.key,
  });
  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: TextApp(
        text: label,
        theme: TextStyle(
          color: textColor,
          fontFamily: FontFamilyHelper.cairoArabic,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
