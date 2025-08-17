import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/extensions/string_exetension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class TeacherHeader extends StatelessWidget {
  const TeacherHeader({required this.userModel, super.key});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        color: context.color.mainColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: CachedNetworkImage(
              height: 80.h,
              width: 80.w,
              fit: BoxFit.cover,
              imageUrl: userModel.userImage.toString(),
              errorWidget: (context, url, error) => Icon(
                Icons.person,
                size: 70.w,
                color: context.color.textColor,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          TextApp(
            text: userModel.userName.toLowerCase().toCapitalized(),
            theme: context.textStyle.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
          SizedBox(height: 5.h),
          TextApp(
            text: userModel.userEmail,
            theme: context.textStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.regular,
            ),
          ),
          SizedBox(height: 5.h),
          TextApp(
            text: userModel.phone,
            theme: context.textStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.regular,
            ),
          ),
          SizedBox(height: 5.h),
          TextApp(
            text: userModel.governorate,
            theme: context.textStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.regular,
            ),
          ),
          SizedBox(height: 5.h),
          TextApp(
            text: 'مدرس ${userModel.subject.toString()}',
            theme: context.textStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.regular,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
