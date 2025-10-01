import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class SignUpButton extends StatelessWidget {
  const SignUpButton({required this.onPressed, super.key});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomFadeInRight(
      duration: 600,
      child: Align(
        child: CustomLinearButton(
          onPressed: onPressed,
          height: 50.h,
          width: MediaQuery.of(context).size.width,
          child: TextApp(
            text: context.translate(LangKeys.register),
            theme: context.textStyle.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
              letterSpacing: 0.5,
              fontFamily: FontFamilyHelper.cairoArabic,
            ),
          ),
        ),
      ),
    );
  }
}
