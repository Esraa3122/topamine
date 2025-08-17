import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class ListStudentChat extends StatelessWidget {
  const ListStudentChat({super.key, this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon(
        //   Icons.chat_bubble_outline_outlined,
        //   color: context.color.textColor,
        // ),
        SizedBox(width: 10.w),
        TextApp(
          text: context.translate(LangKeys.chat),
          theme: context.textStyle.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeightHelper.regular,
          ),
        ),
        const Spacer(),

        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              TextApp(
                text: context.translate(LangKeys.chat).toLowerCase(),
                theme: context.textStyle.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeightHelper.regular,
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.arrow_forward_ios,
                color: context.color.textColor,
                size: 15,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
