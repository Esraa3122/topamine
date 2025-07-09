import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class OnBoardingButton extends StatelessWidget {
  const OnBoardingButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  final void Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return CustomFadeInRight(
      duration: 600,
      child: Align(
        child: CustomLinearButton(
          onPressed: onPressed,
          height: 50.h,
          width: 300.w,
          child: TextApp(
            text: text,
            theme: context.textStyle.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
