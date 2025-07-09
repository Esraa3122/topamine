import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
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
          // width: 300.w,
          child: TextApp(
            text: context.translate(LangKeys.register),
            theme: context.textStyle.copyWith(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.bold,
            ),
          ),
        ),
      ),
    );
    //     BlocConsumer<AuthBloc, AuthState>(
    //       listener: (context, state) {
    //         state.mapOrNull(success: (_) {
    //           ShowToast.showToastSuccessTop(
    //             message: context.translate(LangKeys.loggedSuccessfully),
    //           );
    //           context.pushNamedAndRemoveUntil(AppRoutes.mainDonor);
    //         }, error: (message) {
    //           ShowToast.showToastErrorTop(
    //             message: context.translate(LangKeys.loggedError),
    //           );
    //         });
    //       },
    //       builder: (context, state) {
    //         return state.maybeWhen(loading: () {
    //           return CustomLinearButton(
    //               onPressed: () {},
    //               height: 55.h,
    //               width: MediaQuery.of(context).size.width,
    //               child: const CircularProgressIndicator(
    //                 color: Colors.white,
    //               ));
    //         }, orElse: () {
    //           return CustomFadeInRight(
    //             duration: 600,
    //             child: CustomLinearButton(
    //                 onPressed: () {
    //                   _validateThenDoSignUp(context);
    //                 },
    //                 height: 55.h,
    //                 width: MediaQuery.of(context).size.width,
    //                 child: TextApp(
    //                     text: context.translate(LangKeys.sinup),
    //                     theme: context.textStyle.copyWith(
    //                       fontSize: 18.sp,
    //                       fontWeight: FontWeightHelper.bold,
    //                     ))),
    //           );
    //         });
    //       },
    //     );
    //   }

    //   void _validateThenDoSignUp(BuildContext context) {
    //     final authBloc = context.read<AuthBloc>();
    //     final imageCubit = context.read<UploadImageCubit>();

    //     if (authBloc.formKey.currentState!.validate() ||
    //         imageCubit.getImageUrl.isEmpty) {
    //       if (imageCubit.getImageUrl.isEmpty) {
    //         if (imageCubit.getImageUrl.isEmpty) {
    //           ShowToast.showToastErrorTop(
    //               message: context.translate(LangKeys.validPickImage));
    //         }
    //       } else {
    //         context
    //             .read<AuthBloc>()
    //             .add(AuthEvent.signUp(imagUrl: imageCubit.getImageUrl));
    //       }
    //     }
  }
}
