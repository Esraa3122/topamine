import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/course_details/data/model/student_model.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({required this.student, super.key});
  final StudentModel student;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200.w,
        child: Card(
          color: context.color.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(student.imageUrl),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp(
                  text: student.name,
                  theme: context.textStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                  ),
                ),
              SizedBox(height: 6.h),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => Icon(
                          index < student.rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  TextApp(
                  text: student.subject,
                  theme: context.textStyle.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: context.color.textColor,
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
        )
    );
  }
}
