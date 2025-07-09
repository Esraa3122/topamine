import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/extensions/string_exetension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class TeacherProfileInfo extends StatelessWidget {
  const TeacherProfileInfo({required this.user, super.key});
   final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User Profile image
        ClipRRect(
          borderRadius: BorderRadius.circular(45),
          child: CachedNetworkImage(
            height: 80.h,
            width: 80.w,
            fit: BoxFit.fill,
            imageUrl: '${user.userImage}',
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.red,
              size: 70,
            ),
          ),
        ),
        SizedBox(height: 7.h,),
        TextApp(
          text: user.userName.toLowerCase().toCapitalized(), 
          theme: context.textStyle.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeightHelper.bold
        )),
         SizedBox(height: 7.h,),
        TextApp(
          text: user.userEmail, 
          theme: context.textStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.regular
        )),
         SizedBox(height: 7.h,),
        TextApp(
          text: user.phone, 
          theme: context.textStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.regular
        )),
         SizedBox(height: 7.h,),
        TextApp(
          text: user.governorate, 
          theme: context.textStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.regular
        )),
      ],
    );
  }
}
