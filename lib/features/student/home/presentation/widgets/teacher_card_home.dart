import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/home/data/model/teacher_model_home.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({required this.teacher, super.key});
  final TeacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300.w,
        child: Card(
          color: context.color.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         SizedBox(height: 10.h,),
          ListTile(
            leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(teacher.imageUrl),
          ),
          title: TextApp(
                    text: teacher.name,
                    maxLines: 1,
                    theme: context.textStyle.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor
                    ),),
          subtitle: TextApp(
                    text: teacher.subject,
                    maxLines: 1,
                    theme: context.textStyle.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeightHelper.medium,
                      color: context.color.textColor
                    ),),
          
          trailing: CustomLinearButton(
          width: 50.w,
          height: 30.h,
              onPressed: () {
                context.pushNamed(AppRoutes.teacherProfile2);
              },
              child: const Text('View',style: TextStyle(color: Colors.white),),
          ),
          ),
          
          // SizedBox(height: 8.h),
         
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
              TextApp(
                    text: '(${teacher.reviews} reviews)',
                    maxLines: 1,
                    theme: context.textStyle.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeightHelper.regular,
                      color: context.color.textColor
                    ),),
            ],
          ),
            
        ],
      ),
        )
    );
  }
}
