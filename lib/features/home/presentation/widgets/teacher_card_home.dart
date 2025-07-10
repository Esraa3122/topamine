import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/features/home/data/model/teacher_model_home.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({required this.teacher, super.key});
  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffF3F4F6),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(teacher.imageUrl),
          ),
          SizedBox(height: 8.h),
          Text(
            teacher.name,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            teacher.subject,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Icon(
                index < teacher.rating.round() ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 14,
              ),
            ),
          ),
          Text(
            '(${teacher.reviews} reviews)',
            style: TextStyle(fontSize: 10.sp),
          ),
          SizedBox(height: 5.h),
          SizedBox(
            height: 30.h,
            width: double.infinity,
            child: CustomLinearButton(
              onPressed: () {
                context.pushNamed(AppRoutes.teacherProfile2);
              },
              child: const Text('View'),
            ),
          ),
        ],
      ),
    );
  }
}
