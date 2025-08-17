import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContanierCourseTeacherProfile extends StatelessWidget {
  const CustomContanierCourseTeacherProfile({
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
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
