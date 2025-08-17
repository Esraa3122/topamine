import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/follow_button.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/profile_property.dart';

class CustomShapeProfile extends StatelessWidget {
  const CustomShapeProfile({
    required this.userModel, super.key,
  });

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 60.h),
          padding: EdgeInsets.only(
            top: 60.h,
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          decoration: BoxDecoration(
            color: context.color.mainColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.color.bluePinkLight!.withOpacity(0.5),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              TextApp(
                    text: userModel.userName,
                    theme: context.textStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor
                    ),
                  ),
              if (userModel.subject != null) ...[
                SizedBox(height: 6.h),
                TextApp(
                    text: userModel.subject!,
                    theme: context.textStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.regular,
                      color: Colors.grey
                    ),
                  ),
              ],
              SizedBox(height: 12.h),
              Column(
                children: [
                  ProfileProperty(icon: Icons.email, text: userModel.userEmail,),
                  ProfileProperty(icon: Icons.phone, text: userModel.phone,),
                  ProfileProperty(icon: Icons.location_on_outlined, text: userModel.governorate,)
                ]
              ),
               SizedBox(height: 16.h),
            Center(
              child: FollowButton(
                teacherId: userModel.userId, teacherName: userModel.userName,
              ),
            ),
            ],
            
          ),
        ),

        Positioned(
          top: 0,
          child: CircleAvatar(
            backgroundColor: context.color.textColor,
            radius: 52,
            child: ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: CachedNetworkImage(
            height: 90.h,
            width: 90.w,
            fit: BoxFit.cover,
            imageUrl: '${userModel.userImage}',
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
              size: 70,
            ),
          ),
        ),
          ),
        ),
      ],
    );
  }
}
