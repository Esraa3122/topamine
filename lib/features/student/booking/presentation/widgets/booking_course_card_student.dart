import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class BookingCourseCardStudent extends StatelessWidget {
  const BookingCourseCardStudent({
    required this.course,
    super.key,
    this.showStatus = false,
  });

  final CoursesModel course;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerPage(course: course),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 212, 211, 211).withOpacity(0.8),
              context.color.mainColor!.withOpacity(0.8),
            ],
            begin: const Alignment(0.36, 0.27),
            end: const Alignment(0.58, 0.85),
          ),
          boxShadow: [
            BoxShadow(
              color: context.color.containerShadow1!.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: context.color.containerShadow2!.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  course.imageUrl ?? 'https://via.placeholder.com/150',
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
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
                        course.teacherName,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Created At: ${course.createdAt}',
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
      ),
    );
  }
}
