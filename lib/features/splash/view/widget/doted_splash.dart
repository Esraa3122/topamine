import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DotedSplash extends StatelessWidget {
  const DotedSplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin:  EdgeInsets.symmetric(horizontal: 4.w),
          width: 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 1 ? Colors.white : Colors.white54,
          ),
        );
      }),
    );
  }
}
