import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/onbording/model/list_boarding.dart';
import 'package:test/features/onbording/view/refactor/on_boarding_page.dart';
import 'package:test/features/onbording/view/widgets/custom_indicator.dart';
import 'package:test/features/onbording/view/widgets/on_boarding_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.mainColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  if (pageIndex == 2) {
                    context.pushNamedAndRemoveUntil(AppRoutes.ruleSignUp);
                  } else {
                    _controller.animateToPage(
                      pageIndex + 1,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                },
                child: TextApp(
            text: pageIndex == 2
                      ? context.translate(LangKeys.register)
                      : context.translate(LangKeys.skip),
            theme: context.textStyle.copyWith(
                  color: ColorsLight.pinkLight,
                  fontSize: 15.sp,
                  fontWeight: FontWeightHelper.bold,
                  letterSpacing: 0.5,
                  fontFamily: FontFamilyHelper.cairoArabic,
            ),
          ),
                
              ),
            ),

            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) {
                  setState(() {
                    pageIndex = value;
                  });
                },
                itemBuilder: (context, index) =>
                    OnBoardingPage(page: pages[index]),
                itemCount: pages.length,
              ),
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIndicator(
                  active: pageIndex == 0,
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomIndicator(
                  active: pageIndex == 1,
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomIndicator(
                  active: pageIndex == 2,
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OnBoardingButton(
                      onPressed: () {
                        if (pageIndex == 2) {
                          context.pushNamedAndRemoveUntil(AppRoutes.login);
                        } else {
                          _controller.animateToPage(
                            pageIndex + 1,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear,
                          );
                        }
                      },
                      text: pageIndex == 2
                          ? context.translate(LangKeys.login)
                          : context.translate(LangKeys.contnue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
