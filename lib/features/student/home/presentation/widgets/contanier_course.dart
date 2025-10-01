import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/home/presentation/widgets/rating.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class ContanierCourse extends StatelessWidget {
  const ContanierCourse({required this.course, super.key});
  final CoursesModel course;

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.courseDetails,
          arguments: course,
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 2,
        shadowColor: context.color.bluePinkLight!.withOpacity(0.5),
        color: context.color.mainColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12.r),
                    ),
                    child: Image.network(
                      course.imageUrl ?? '',
                      // height: 120.h,
                      // width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      // color: context.color.bluePinkLight,
                      gradient: LinearGradient(
                        colors: [
                          context.color.bluePinkLight!,
                          context.color.bluePinkDark!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextApp(
                      text: '${course.price} ${context.translate(LangKeys.eGP)}',
                      theme: context.textStyle.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.bold,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp(
                    text: course.title,
                    maxLines: 1,
                    theme: context.textStyle.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor,
                      fontFamily: FontFamilyHelper.cairoArabic,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  TextApp(
                    text: course.teacherName,
                    theme: context.textStyle.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeightHelper.medium,
                      color: Colors.grey.shade700,
                      fontFamily: FontFamilyHelper.cairoArabic,
                    ),
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: RatingWidget(courseId: course.id.toString()),
                  ),

                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 16.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      TextApp(
                        text:
                            '${context.translate(LangKeys.startDate)} ${_formatTime(course.createdAt)}',
                        theme: context.textStyle.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16, color: Colors.grey),
                      SizedBox(width: 4.w),
                      TextApp(
                        text:
                            '${context.translate(LangKeys.endDate)} ${_formatTime(course.endDate)}',
                        theme: context.textStyle.copyWith(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, bottom: 8.h, left: 10.w),
                child: Row(
                  children: [
                    TextApp(
                      text: context.translate(LangKeys.viewDetails),
                      theme: context.textStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: context.color.bluePinkLight,
                        letterSpacing: 0.5,
                        fontFamily: FontFamilyHelper.cairoArabic,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: context.color.bluePinkLight,
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
