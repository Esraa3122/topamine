import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/onbording/model/on_boarding_page_data.dart';


class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({required this.page, super.key});

  final OnBoardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: 30.h),
          Lottie.asset(page.onBoardingImage, width: 326.w, height: 300.h),
          SizedBox(height: 10.h),
          TextApp(
            text: context.translate(page.onBoardingTitle),
            textAlign: TextAlign.center,
            theme: context.textStyle.copyWith(
                  color: context.color.textColor,
                  fontSize: 30.sp,
                  letterSpacing: 0.5,
                  fontWeight: FontWeightHelper.bold,
                  fontFamily: FontFamilyHelper.cairoArabic,
            ),
          ),
          TextApp(
            text: context.translate(page.onBoardingDescription),
            textAlign: TextAlign.center,
            theme: context.textStyle.copyWith(
                  color: ColorsLight.grey9FColor,
                  fontSize: 17.sp,
                  letterSpacing: 0.5,
                  fontWeight: FontWeightHelper.medium,
                  fontFamily: FontFamilyHelper.cairoArabic,
            ),
          ),
        ],
      ),
    );
  }
}
