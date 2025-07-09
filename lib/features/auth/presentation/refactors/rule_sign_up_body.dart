import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/presentation/widgets/dark_and_lang_buttons.dart';

class RuleSignUpBody extends StatelessWidget {
  const RuleSignUpBody({super.key});

  Future<void> _selectRole(BuildContext context, UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role.name);

    if (role == UserRole.teacher) {
      await context.pushNamed(AppRoutes.signUpTeacher);
    } else {
      await context.pushNamed(AppRoutes.signUpStudent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: [
          //Dark mode and language
          const DarkAndLangButtons(),
          SizedBox(
            height: 100.h,
          ),
          TextApp(
            text: context.translate(LangKeys.joinToTopamine),
            theme: context.textStyle.copyWith(
              color: ColorsLight.pinkLight,
              fontSize: 26.sp,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
          SizedBox(height: 10.h),
          TextApp(
            text: context.translate(LangKeys.chooseYourRole),
            theme: context.textStyle.copyWith(
              color: ColorsLight.grey9FColor,
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.medium,
            ),
          ),
          SizedBox(height: 32.h),

          // Teacher Card
          GestureDetector(
            onTap: () => _selectRole(context, UserRole.teacher),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: ColorsLight.greyCFColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.white, blurRadius: 6),
                ],
              ),
              child: Column(
                children: [
                  SvgPicture.asset(AppImages.teacher),
                  SizedBox(height: 10.h),

                  TextApp(
                    text: context.translate(LangKeys.iAmATeacher),
                    theme: context.textStyle.copyWith(
                      color: const Color(0xFF3a6ea5),
                      fontSize: 18.sp,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),

                  SizedBox(height: 10.h),
                  TextApp(
                    textAlign: TextAlign.center,
                    text: context.translate(LangKeys.descriptionRoleTeacher),
                    theme: context.textStyle.copyWith(
                      color: Colors.black54,
                      fontSize: 15.sp,
                      fontWeight: FontWeightHelper.regular,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Student Card
          GestureDetector(
            onTap: () => _selectRole(context, UserRole.student),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorsLight.greyCFColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.white, blurRadius: 6),
                ],
              ),
              child: Column(
                children: [
                  SvgPicture.asset(AppImages.student),
                  SizedBox(height: 10.h),
                   TextApp(
                    text: context.translate(LangKeys.iAmAStudent),
                    theme: context.textStyle.copyWith(
                      color: const Color(0xFF3a6ea5),
                      fontSize: 18.sp,
                      fontWeight: FontWeightHelper.bold,
                    ),
                  ),

                  SizedBox(height: 10.h),
                  TextApp(
                    textAlign: TextAlign.center,
                    text: context.translate(LangKeys.descriptionRoleStudent),
                    theme: context.textStyle.copyWith(
                      color: Colors.black54,
                      fontSize: 15.sp,
                      fontWeight: FontWeightHelper.regular,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // Go To Sign Up Screen
          CustomFadeInDown(
            duration: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextApp(
                  text: context.translate(LangKeys.doYouHaveAnAccount),
                  theme: context.textStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: context.color.textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.pushReplacementNamed(AppRoutes.login);
                  },
                  child: TextApp(
                    text: context.translate(LangKeys.login),
                    theme: context.textStyle.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.bluePinkLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
