import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_shimmer_card.dart';

class BookingStudentShimmerScreen extends StatelessWidget {
  const BookingStudentShimmerScreen({super.key});

  Widget _buildShimmerBox({
    double? width,
    double? height,
    BorderRadius? radius,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 16.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: radius ?? BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerBox(
              width: 120.w,
              height: 20.h,
              radius: BorderRadius.circular(4),
            ),
            SizedBox(height: 10.h),

            _buildShimmerBox(
              width: double.infinity,
              height: 50.h,
              radius: BorderRadius.circular(12),
            ),
            SizedBox(height: 20.h),

            _buildShimmerBox(
              width: double.infinity,
              height: 40.h,
              radius: BorderRadius.circular(12),
            ),
            SizedBox(height: 20.h),

            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) =>
                    const BookingCourseShimmerCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
