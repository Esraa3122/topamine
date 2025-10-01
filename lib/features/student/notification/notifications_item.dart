import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/common/toast/gradient_snack_bar.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class NotificationsItem extends StatelessWidget {
  const NotificationsItem({
    required this.title,
    required this.body,
    required this.courseId,
    super.key,
    this.createdAt,
  });
  final String title;
  final String body;
  final DateTime? createdAt;
  final String courseId;

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعة';
    } else {
      return '${difference.inDays} يوم';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final snapshot = await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get();

        if (!snapshot.exists) {
          GradientSnackBar.show(
            context,
            'الكورس غير موجود',
            context.color.bluePinkLight!,
            context.color.bluePinkDark!,
          );
          return;
        }

        final courseData = snapshot.data()!;
        final course = CoursesModel.fromJson(courseData);

        final endDate = courseData['endDate'] != null
            ? (courseData['endDate'] as Timestamp).toDate()
            : null;

        if (endDate != null && DateTime.now().isAfter(endDate)) {
          GradientSnackBar.show(
            context,
            'مدة الكورس انتهت',
            context.color.bluePinkLight!,
            context.color.bluePinkDark!,
          );
          return;
        }

        await context.pushNamed(
          AppRoutes.courseDetails,
          arguments: course,
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: context.color.mainColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50.h,
              width: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow.shade100,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppImages.notificationIcon,
                  color: Colors.yellow[700],
                  height: 26.h,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp(
                    text: title,
                    theme: context.textStyle.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor,
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  TextApp(
                    text: body,
                    theme: context.textStyle.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeightHelper.medium,
                      color: context.color.textColor?.withOpacity(0.85),
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextApp(
                        text: _formatDate(createdAt),
                        theme: context.textStyle.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeightHelper.medium,
                          color: Colors.grey,
                          fontFamily: FontFamilyHelper.cairoArabic,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14.sp,
                        color: Colors.grey,
                      ),
                    ],
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
