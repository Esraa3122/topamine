import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BulletItem extends StatelessWidget {
  const BulletItem({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.blue, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
