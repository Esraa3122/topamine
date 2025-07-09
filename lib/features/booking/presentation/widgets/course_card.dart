import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/home/data/model/coures_model.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({required this.course, super.key, this.showStatus = false});
  final CourseModel course;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin:  EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                course.image,
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      course.teacher,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Enrolled: ${course.enrolledDate}',
                      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                    ),
                    if (showStatus) ...[
                      SizedBox(height: 4.h),
                      Text(
                        course.status == 'completed'
                            ? 'Completed'
                            : 'In Progress',
                        style: TextStyle(
                          color: course.status == 'completed'
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
