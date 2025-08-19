import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/presentation/widgets/forget_password/forget_password_button.dart';
import 'package:test/features/auth/presentation/widgets/forget_password/forget_password_text_form.dart';

class ForgetPasswordBody extends StatefulWidget {
  const ForgetPasswordBody({super.key});

  @override
  State<ForgetPasswordBody> createState() => _ForgetPasswordBodyState();
}

class _ForgetPasswordBodyState extends State<ForgetPasswordBody> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void resetPassword() {
    if (emailController.text.isEmpty) {
      AwesomeSnackBar.show(
            context: context,
            title: 'Error!',
            message: context.translate(LangKeys.enterYourEmailAddress),
            contentType: ContentType.failure,
          );
    }

    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim())
        .then((_) {
          AwesomeSnackBar.show(
            context: context,
            title: 'Success!',
            message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
            contentType: ContentType.success,
          );
          // ShowToast.showToastSuccessTop(
          //   message: context.translate(LangKeys.resetPassword),
          // );
          context.pushNamedAndRemoveUntil(AppRoutes.login);
        })
        .catchError((error) {
            AwesomeSnackBar.show(
            context: context,
            title: 'Error!',
            message: context.translate(LangKeys.enterYourEmailAddress),
            contentType: ContentType.failure,
          );
          // ShowToast.showToastErrorTop(
          //   message: context.translate(LangKeys.enterYourEmailAddress),
          // );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(
              height: 20.h,
            ),
            //arrow back
            CustomFadeInRight(
              duration: 400,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomLinearButton(
                  onPressed: () {
                    context.pop();
                  },
                  height: 44.h,
                  width: 50.h,
                  child: SvgPicture.asset(AppImages.backButton),
                ),
              ),
            ),
             SizedBox(
              height: 100.h,
            ),
            Center(
              child: TextApp(
                text: context.translate(
                  LangKeys.enterYourEmailAddressToResetPassword,
                ),
                theme: context.textStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            TextFildForgetPassword(
              emailcontroller: emailController,
              formKey: _formKey,
            ),
            SizedBox(
              height: 30.h,
            ),
            ForgetPasswordBotton(
              onPressed: resetPassword,
            ),
          ],
        ),
      ),
    );
  }
}
