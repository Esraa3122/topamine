import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({required this.onPressed, super.key});
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
            text: context.translate(LangKeys.login),
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

  // BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
  //   state.whenOrNull(success: (userRole) {
  //     ShowToast.showToastSuccessTop(
  //         message: context.translate(LangKeys.loggedSuccessfully));
  //     if (userRole == 'admin') {
  //       context.pushNamedAndRemoveUntil(AppRoutes.homeAdmin);
  //     } else {
  //       context.pushNamedAndRemoveUntil(AppRoutes.mainDonor);
  //     }
  //   }, error: (message) {
  //     ShowToast.showToastErrorTop(
  //         message: context.translate(LangKeys.loggedError));
  //   });
  // }, builder: (context, state) {
  //   return state.maybeWhen(
  //     loading: () {
  //       return CustomLinearButton(
  //           onPressed: () {},
  //           height: 45.h,
  //           // width: MediaQuery.of(context).size.width,
  //           width: 300.w,
  //           child: const CircularProgressIndicator(
  //             color: Colors.white,
  //           ));
  //     },
  //     orElse: () {
  //       return CustomLinearButton(
  //           onPressed: () {
  //             _validateThenDoLogein(context);
  //           },
  //           height: 45.h,
  //           // width: MediaQuery.of(context).size.width,
  //           width: 300.w,
  //           child: TextApp(
  //               text: context.translate(LangKeys.login),
  //               theme: context.textStyle.copyWith(
  //                 fontSize: 18.sp,
  //                 fontWeight: FontWeightHelper.bold,
  //               )));
  //     },
  //   );
  // },),);
}

//   void _validateThenDoLogein(BuildContext context) {
//     if (context.read<AuthBloc>().formKey.currentState!.validate()) {
//       context.read<AuthBloc>().add(const AuthEvent.login());
//     }
//   }
// }
