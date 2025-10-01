import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/images/app_images.dart';

class Message extends StatelessWidget {
  const Message({this.message = '', this.isUser = false, super.key});
  final String message;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!isUser)
          CircleAvatar(
            radius: 16.r,
            backgroundColor: Colors.blue.shade200,
            child: SvgPicture.asset(
              AppImages.chatboot,
              color: Colors.white,
              height: 25.h,
            ),
          ),
        SizedBox(width: 8.w),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isUser
                    ? [Colors.blue.shade300, Colors.blue.shade600]
                    : [context.color.chatboot!, Colors.grey.shade300],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(2, 2),
                ),
              ],
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
                topRight: isUser ? Radius.circular(12.r) : Radius.zero,
                topLeft: isUser ? Radius.zero : Radius.circular(12.r),
              ),
            ),
            child: TextApp(
              text:  message,
              theme: TextStyle(
                fontSize: 15.sp,
                color: isUser ? Colors.white : context.color.textColor,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5
              ),
            ),
          ),
        ),
        if (isUser) SizedBox(width: 8.w),
        if (isUser)
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue.shade500,
            child: Icon(Icons.person, color: Colors.white, size: 18.sp),
          ),
      ],
    );
  }
}
