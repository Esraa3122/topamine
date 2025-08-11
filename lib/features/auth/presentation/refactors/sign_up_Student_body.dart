import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/toast/show_toast.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/enums/rule_register.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_state.dart';
import 'package:test/features/auth/presentation/widgets/auth_title_info.dart';
import 'package:test/features/auth/presentation/widgets/sign_up/sign_up_button.dart';
import 'package:test/features/auth/presentation/widgets/sign_up/sign_up_text_form_student.dart';
import 'package:test/features/auth/presentation/widgets/sign_up/user_avatar_image.dart';

class SignUpStudentBody extends StatefulWidget {
  const SignUpStudentBody({super.key});

  @override
  State<SignUpStudentBody> createState() => _SignUpStudentBodyState();
}

class _SignUpStudentBodyState extends State<SignUpStudentBody> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final gradeController = TextEditingController();
  final phoneController = TextEditingController();
  final governorateController = TextEditingController();
  File? uploadedImageUrl;

  void _registerStudent() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: UserRole.student,
        grade: gradeController.text.trim(),
        phone: phoneController.text.trim(),
        governorate: governorateController.text.trim(),
        imageFile: uploadedImageUrl,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async{
        if (state is AuthSuccess) {
          ShowToast.showToastSuccessTop(
            message: context.translate(state.successMessage),
          );
          await context.pushNamedAndRemoveUntil(AppRoutes.login);
        } else if (state is AuthFailure) {
          ShowToast.showToastErrorTop(
            message: context.translate(state.errorMessage),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                      width: 50.w,
                      child: SvgPicture.asset(AppImages.backButton),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                // welcome Info
                AuthTitleInfo(
                  title: context.translate(LangKeys.createAStudentAccount),
                  description: context.translate(
                    LangKeys.completeYourAccountToStartStudent,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                //User Avatar image
                UserAvatarImage(onImageUploaded: (imageUrl) {
                  uploadedImageUrl = imageUrl;
                }),

                SizedBox(
                  height: 15.h,
                ),

                // SignUp TextForm
                SignUpTextFormStudent(
                  namecontroller: nameController,
                  emailcontroller: emailController,
                  passwordcontroller: passwordController,
                  phonecontroller: phoneController,
                  gradecontroller: gradeController,
                  governoratecontroller: governorateController,
                  formKey: _formKey,
                ),

                SizedBox(
                  height: 20.h,
                ),
                //SignUpButton
                SignUpButton(
                  onPressed: _registerStudent,
                ),

                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
