import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class BulletItem extends StatelessWidget {
  const BulletItem({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: context.color.bluePinkLight, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(child: TextApp(
          text: text,
          theme: context.textStyle.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeightHelper.regular,
            color: context.color.textColor,
            height: 1.5.h
          ),
        ),),
        ],
      ),
    );
  }
}
