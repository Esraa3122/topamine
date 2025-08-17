import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

   String formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'انتهى';
    }
    final days = duration.inDays;
    return '$days يوم';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = course.endDate;
    final difference = endDate!.difference(now);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('enrollments')
          .where('courseId', isEqualTo: course.id)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final doc = snapshot.data!.docs.first;
        final enrollmentId = doc.id;
        final data = doc.data() as Map<String, dynamic>;

        double progress = (data['progress'] ?? 0.0) as double;
        String status = data['statusProgress'] as String? ?? 'inProgress';

        final Color statusShadowColor = status == 'completed'
    ? Colors.green[300]!.withOpacity(0.3)
    : Colors.orange[300]!.withOpacity(0.3);

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
                  context.color.mainColor!,
                  context.color.mainColor!.withOpacity(0.8),
                ],
                begin: const Alignment(0.36, 0.27),
                end: const Alignment(0.58, 0.85),
              ),
              boxShadow: [
                BoxShadow(
                  color: statusShadowColor,
                  offset: const Offset(0, 2),
                  blurRadius: 2,
                ),
                BoxShadow(
                  color: statusShadowColor,
                  offset: const Offset(0, 2),
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
                              color: context.color.textColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            course.teacherName,
                            style: TextStyle(color: context.color.textColor),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'متبقى ${formatDuration(difference)} على انتهاء الكورس',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade300,
                            color: status == 'completed'
                                    ? Colors.green
                                    : Colors.orange[300],
                            borderRadius: BorderRadius.circular(8),
                            minHeight: 6,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: context.color.textColor,
                            ),
                          ),
                          if (showStatus) ...[
                            SizedBox(height: 4.h),
                            Text(
                              status == 'completed'
                                  ? 'Completed'
                                  : 'In Progress',
                              style: TextStyle(
                                color: status == 'completed'
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
      },
    );
  }
}