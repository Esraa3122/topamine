import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class BookingCourseCardStudent extends StatefulWidget {
  const BookingCourseCardStudent({
    required this.course,
    super.key,
    this.showStatus = false,
  });

  final CoursesModel course;
  final bool showStatus;

  @override
  State<BookingCourseCardStudent> createState() =>
      _BookingCourseCardStudentState();
}

class _BookingCourseCardStudentState extends State<BookingCourseCardStudent> {
  double _scale = 1;

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
    final endDate = widget.course.endDate;
    final difference = endDate!.difference(now);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('enrollments')
          .where('courseId', isEqualTo: widget.course.id)
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final doc = snapshot.data!.docs.first;
        final data = doc.data()! as Map<String, dynamic>;

        final progress = (data['progress'] ?? 0.0) as double;
        final status = data['statusProgress'] as String? ?? 'inProgress';

        final statusColor = status == 'completed'
            ? Colors.green
            : Colors.orange;

        return GestureDetector(
          onTapDown: (_) => setState(() => _scale = 0.97),
          onTapUp: (_) => setState(() => _scale = 1.0),
          onTapCancel: () => setState(() => _scale = 1.0),
          onTap: () {
            context.pushNamed(
              AppRoutes.videoPlayerScreen,
              arguments: widget.course,
            );
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: _scale,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    context.color.mainColor!,
                    context.color.mainColor!.withOpacity(0.8),
                    // context.color.mainColor!.withOpacity(0.4),
                  ],
                  begin: const Alignment(0.36, 0.27),
                  end: const Alignment(0.58, 0.85),
                ),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withOpacity(0.3),
                    blurRadius: 4,
                    // spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.course.imageUrl ??
                                    'https://via.placeholder.com/150',
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            // Badge صغيرة للحالة
                            Positioned(
                              top: 6,
                              left: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextApp(
                                  text: status == 'completed' ? 'مكتمل' : 'فى تقدم',
                                  theme: context.textStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: FontFamilyHelper.cairoArabic,
                                    letterSpacing: 0.5
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextApp(
                                  text: widget.course.title,
                                  theme: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeightHelper.bold,
                                    color: context.color.textColor,
                                    fontFamily: FontFamilyHelper.cairoArabic,
                                    letterSpacing: 0.5,
                                  ),
                                  textOverflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 14,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 4),
                                    TextApp(
                                      text: widget.course.teacherName,
                                      theme: TextStyle(
                                        color: context.color.textColor,
                                      fontWeight: FontWeightHelper.medium,
                                      fontSize: 13.sp,
                                        fontFamily:
                                            FontFamilyHelper.cairoArabic,
                                        letterSpacing: 0.5
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Chip(
                                      label: Row(
                                        children: [
                                          const Icon(
                                            Icons.timer,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          TextApp(
                                           text: difference.isNegative
                                                ? 'انتهى'
                                                : 'ينتهي خلال ${formatDuration(difference)}',
                                            theme: context.textStyle.copyWith(
                                              fontSize: 11.sp,
                                              color: Colors.white,
                                              fontFamily:
                                            FontFamilyHelper.cairoArabic,
                                            fontWeight: FontWeightHelper.regular,
                                            letterSpacing: 0.5
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: difference.inDays == 0
                                          ? Colors.red.shade400
                                          : (difference.inDays <= 7
                                                ? Colors.orange.shade400
                                                : Colors.grey.shade400),
                                      padding: EdgeInsets.zero,
                                      side: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                // Progress + نسبة
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.grey.shade200,
                                        color: statusColor,
                                        borderRadius: BorderRadius.circular(8),
                                        minHeight: 6,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextApp(
                                      text:
                                          '${(progress * 100).toStringAsFixed(0)}%',
                                      theme: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeightHelper.regular,
                                        color: context.color.textColor,
                                        fontFamily:
                                            FontFamilyHelper.cairoArabic,
                                        letterSpacing: 0.5
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
