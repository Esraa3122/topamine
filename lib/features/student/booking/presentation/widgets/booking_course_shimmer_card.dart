import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BookingCourseShimmerCard extends StatelessWidget {
  const BookingCourseShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: Colors.grey.shade300,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade300,
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16.h,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 150.w,
                    height: 14.h,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 120.w,
                    height: 12.h,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: double.infinity,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    width: 40.w,
                    height: 12.h,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
