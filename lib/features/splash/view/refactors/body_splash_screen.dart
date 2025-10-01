import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/splash/view/widget/animation_splash_screen.dart';
import 'package:test/features/splash/view/widget/container_logo_splash.dart';


class BodySplashScreen extends StatelessWidget {
  const BodySplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorsLight.pinkDark, 
            ColorsLight.pinkLight,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 100,
            left: 60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 2,
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 180,
            child: Transform.rotate(
              angle: 0.8,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),

          // Main content
          CustomFadeInUp(
            duration: 4000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const ContainerLogoSplash(),
                SizedBox(height: 30.h),

              TextApp(
                text: context.translate(LangKeys.appName),
                theme: context.textStyle.copyWith(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeightHelper.bold,
                  fontFamily: FontFamilyHelper.cairoArabic,
                  letterSpacing: 0.5,
                ),),
              
                SizedBox(height: 10.h),
                
                TextApp(
                text: context.translate(LangKeys.appDescription),
                theme: context.textStyle.copyWith(
                  color: Colors.white70,
                  fontSize: 16.sp,
                  fontWeight: FontWeightHelper.regular,
                  fontFamily: FontFamilyHelper.cairoArabic,
                  letterSpacing: 0.5,
                ),),
                SizedBox(height: 30.h),
                const AnimationSplashScreen()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
