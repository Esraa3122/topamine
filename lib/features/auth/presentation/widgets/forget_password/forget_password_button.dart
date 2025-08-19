import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class ForgetPasswordBotton extends StatefulWidget {
  const ForgetPasswordBotton({required this.onPressed, super.key});

  final void Function() onPressed;

  @override
  State<ForgetPasswordBotton> createState() => _ForgetPasswordBottonState();
}

class _ForgetPasswordBottonState extends State<ForgetPasswordBotton> {
  @override
  Widget build(BuildContext context) {
    return CustomLinearButton(
      onPressed: widget.onPressed,
      height: 45.h,
      width: 330.w,
      child: TextApp(
        text: context.translate(LangKeys.resetPassword),
        theme: context.textStyle.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeightHelper.bold,
          color: Colors.white
        ),
      ),
    );
  }
}
