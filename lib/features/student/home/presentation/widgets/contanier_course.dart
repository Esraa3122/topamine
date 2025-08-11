import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

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
      child: SizedBox(
        width: 200.w,
        child: Card(
          color: context.color.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  course.imageUrl ?? '',
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextApp(
                      text: course.title,
                      theme: context.textStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: context.color.textColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    TextApp(
                      text: course.subTitle ?? '',
                      theme: context.textStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.medium,
                        color: context.color.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    TextApp(
                      text: 'Created at: ${_formatTime(course.createdAt)}',
                      theme: context.textStyle.copyWith(
                        color: Colors.grey,
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.regular,
                      ),
                    ),
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
