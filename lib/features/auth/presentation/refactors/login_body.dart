import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/common/toast/buildawesomedialog.dart';
import 'package:test/core/common/toast/show_toast.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/enums/status_register.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/shared_pref/shared_pref_helper.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_state.dart';
import 'package:test/features/auth/presentation/widgets/auth_title_info.dart';
import 'package:test/features/auth/presentation/widgets/dark_and_lang_buttons.dart';
import 'package:test/features/auth/presentation/widgets/login/login_button.dart';
import 'package:test/features/auth/presentation/widgets/login/login_text_form.dart';
import 'package:test/features/splash/view/widget/container_logo_splash.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});
  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthWaitingApproval) {
          // await context.pushNamedAndRemoveUntil(AppRoutes.waitingApproval);
          buildAwesomeDialogWarning(
            'Warning!',
            'حسابك قيد المراجعة',
            context,
          );
          return;
        }

        if (state is AuthSuccess) {
          AwesomeSnackBar.show(
            context: context,
            title: 'Success!',
            message: context.translate(state.successMessage),
            contentType: ContentType.success,
          );

          final user = state.user;

          if (user!.status == AccountStatus.accepted) {
            if (user.userRole == UserRole.teacher) {
              await context.pushNamedAndRemoveUntil(
                AppRoutes.navigationTeacher,
              );
            } else if (user.userRole == UserRole.student) {
              await context.pushNamedAndRemoveUntil(
                AppRoutes.navigationStudent,
              );
            } else {
              ShowToast.showToastErrorTop(message: LangKeys.roleNotFound);
              await SharedPrefHelper().clearSession();
            }
          }
        }

        if (state is AuthFailure) {
          // ShowToast.showToastErrorTop(message: state.errorMessage);
          AwesomeSnackBar.show(
            context: context,
            title: 'Error!',
            message: state.errorMessage,
            contentType: ContentType.failure,
          );
        }
      },

      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Dark mode and language
                const DarkAndLangButtons(),

                SizedBox(
                  height: 50.h,
                ),

                const CustomFadeInDown( 
                  duration: 800,
                  child: ContainerLogoSplash()),

                SizedBox(
                  height: 10.h,
                ),
                // Welcome Info
                AuthTitleInfo(
                  title: context.translate(LangKeys.welcomBack),
                  description: context.translate(LangKeys.descriptionLogin),
                ),

                SizedBox(
                  height: 30.h,
                ),

                // login TextForm
                LoginTextForm(
                  emailcontroller: emailController,
                  passwordcontroller: passwordController,
                  formKey: _formKey,
                ),

                SizedBox(
                  height: 20.h,
                ),

                // forget password
                CustomFadeInLeft(
                  duration: 400,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        context.pushNamed(AppRoutes.forgetPassword);
                      },
                      child: TextApp(
                        text: context.translate(LangKeys.forgetPassword),
                        theme: context.textStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeightHelper.bold,
                          color: context.color.bluePinkLight,
                          letterSpacing: 0.5,
                          fontFamily: FontFamilyHelper.cairoArabic,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),

                // LoginButton
                if (state is AuthLoading)
                   Center(
                    child: SpinKitSpinningLines(
                            color: context.color.bluePinkLight!,
                            size: 50.sp,
                          ),
                  )
                else
                LoginButton(
                  onPressed: _login,
                ),

                // SizedBox(
                //   height: 30.h,
                // ),

                // Row(
                //   children: [
                //     const Expanded(child: Divider()),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 10.w),
                //       child: TextApp(
                //         text: context.translate(LangKeys.or),
                //         theme: context.textStyle.copyWith(
                //           fontSize: 14.sp,
                //           fontWeight: FontWeightHelper.regular,
                //           color: context.color.textColor,
                //         ),
                //       ),
                //     ),
                //     const Expanded(child: Divider()),
                //   ],
                // ),

                // SizedBox(
                //   height: 30.h,
                // ),
                // const SigninWithGoogle(),
                SizedBox(
                  height: 20.h,
                ),

                // Go To Sign Up Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextApp(
                      text: context.translate(LangKeys.dontHaveAnAccount),
                      theme: context.textStyle.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeightHelper.regular,
                        color: context.color.textColor,
                        letterSpacing: 0.5,
                         fontFamily: FontFamilyHelper.cairoArabic,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushReplacementNamed(AppRoutes.ruleSignUp);
                      },
                      child: TextApp(
                        text: context.translate(LangKeys.register),
                        theme: context.textStyle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeightHelper.bold,
                          color: context.color.bluePinkLight,
                          letterSpacing: 0.5,
                          fontFamily: FontFamilyHelper.cairoArabic,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
