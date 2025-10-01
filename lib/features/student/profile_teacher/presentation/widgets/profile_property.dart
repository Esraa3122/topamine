import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class ProfileProperty extends StatelessWidget {
  const ProfileProperty({required this.icon, required this.text, super.key});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: Colors.grey,
          ),
          SizedBox(width: 8.w),
          TextApp(
            text: text,
            theme: context.textStyle.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeightHelper.regular,
              height: 1.5.h,
              color: context.color.textColor,
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
