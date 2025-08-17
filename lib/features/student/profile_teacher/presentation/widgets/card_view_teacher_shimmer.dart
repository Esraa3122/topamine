import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CardViewTeacherShimmer extends StatelessWidget {
  const CardViewTeacherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade300,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Shimmer(
                color: Colors.grey.shade300,
                colorOpacity: 0.3,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // النصوص
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer(
                      color: Colors.grey.shade300,
                      colorOpacity: 0.3,
                      child: Container(
                        height: 16.h,
                        width: 120.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer(
                      color: Colors.grey.shade300,
                      colorOpacity: 0.3,
                      child: Container(
                        height: 14.h,
                        width: 100.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer(
                      color: Colors.grey.shade300,
                      colorOpacity: 0.3,
                      child: Container(
                        height: 14.h,
                        width: 80.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer(
                      color: Colors.grey.shade300,
                      colorOpacity: 0.3,
                      child: Container(
                        height: 12.h,
                        width: 100.w,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Shimmer(
                      color: Colors.grey.shade300,
                      colorOpacity: 0.3,
                      child: Container(
                        height: 12.h,
                        width: 100.w,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
