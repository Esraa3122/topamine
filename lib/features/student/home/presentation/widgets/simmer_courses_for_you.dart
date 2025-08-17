import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CourseCardShimmer extends StatelessWidget {
  const CourseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: Shimmer(
        duration: const Duration(seconds: 2),
        interval: const Duration(milliseconds: 500),
        color: Colors.grey.shade300,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 18.h, width: 150.w, color: Colors.grey.shade300),
                    SizedBox(height: 6.h),
                    Container(height: 14.h, width: 100.w, color: Colors.grey.shade300),
                    SizedBox(height: 6.h),
                    Container(height: 14.h, width: 70.w, color: Colors.grey.shade300),
                    SizedBox(height: 6.h),
                    Container(height: 12.h, width: 120.w, color: Colors.grey.shade300),
                    SizedBox(height: 4.h),
                    Container(height: 12.h, width: 130.w, color: Colors.grey.shade300),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
