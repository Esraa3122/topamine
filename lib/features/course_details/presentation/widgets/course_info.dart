import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        Icon(icon, color: Colors.grey[700]),
        SizedBox(height: 4.h),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          sub,
          style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
        ),
      ],
    );
  }
}
