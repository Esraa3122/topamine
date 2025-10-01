import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class CardViewTeacher extends StatelessWidget {
  const CardViewTeacher({required this.course, super.key});
  final CoursesModel course;
  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
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
                      color: context.color.bluePinkLight!,
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: context.color.containerShadow1!,
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
                course.imageUrl!,
                errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.w),
            SizedBox(width: 16.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      text: course.title,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                      theme: context.textStyle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: context.color.textColor,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                       Icon(Icons.person, size: 14, color: context.color.textColor),
                        SizedBox(width: 4.w),
                        TextApp(
                          text: course.teacherName,
                          theme: context.textStyle.copyWith(
                            color: context.color.textColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeightHelper.regular,
                            fontFamily: FontFamilyHelper.cairoArabic,
                            letterSpacing: 0.5
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: 6.h),
                     Row(
                       children: [
                          Icon(Icons.monetization_on, size: 14, color: context.color.bluePinkLight),
                        SizedBox(width: 4.w),
                         TextApp(
                          text: '${context.translate(LangKeys.price)} ${course.price} EGP',
                          theme: context.textStyle.copyWith(
                            color: context.color.bluePinkLight,
                            fontSize: 14.sp,
                            fontWeight: FontWeightHelper.regular,
                            fontFamily: FontFamilyHelper.cairoArabic,
                            letterSpacing: 0.5
                          ),
                                             ),
                       ],
                     ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        const Icon(Icons.date_range, size: 14, color: Colors.grey),
                        SizedBox(width: 4.w),
                        TextApp(
                          text: '${context.translate(LangKeys.startDate)} ${_formatTime(course.createdAt)}',
                          theme: context.textStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeightHelper.regular,
                            fontFamily: FontFamilyHelper.cairoArabic,
                            letterSpacing: 0.5
                          ),
                        ),
                      ],
                    ),
                     Row(
                      children: [
                        const Icon(Icons.event, size: 14, color: Colors.grey),
                        SizedBox(width: 4.w),
                         TextApp(
                          text: '${context.translate(LangKeys.endDate)} ${_formatTime(course.endDate)}',
                          theme: context.textStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 12.sp,
                            fontWeight: FontWeightHelper.regular,
                            fontFamily: FontFamilyHelper.cairoArabic,
                            letterSpacing: 0.5
                          ),
                                             ),
                       ],
                     ),
                  ],
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.blueGrey, size: 16),
          ],
        ),
      ),
    );
  }
}
