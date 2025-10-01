import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/extensions/string_exetension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({required this.userModel, super.key});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230.w,
      decoration: BoxDecoration(
        color: context.color.mainColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 10.h),
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
                fontSize: 15.sp,
                fontWeight: FontWeightHelper.bold,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 5.h),
            TextApp(
              text: userModel.userEmail,
              theme: context.textStyle.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeightHelper.regular,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 5.h),
            TextApp(
              text: userModel.governorate,
              theme: context.textStyle.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeightHelper.regular,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 5.h),
            TextApp(
              text: userModel.grade.toString(),
              theme: context.textStyle.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeightHelper.regular,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
