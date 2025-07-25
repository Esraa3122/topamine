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
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:test/features/auth/presentation/widgets/auth_title_info.dart';
import 'package:test/features/auth/presentation/widgets/sign_up/sign_up_button.dart';
import 'package:test/features/auth/presentation/widgets/sign_up/sign_up_text_form_teacher.dart';
import 'package:test/features/auth/presentation/widgets/sign_up/user_avatar_image.dart';

class SignUpTeacherBody extends StatefulWidget {
  const SignUpTeacherBody({super.key});

  @override
  State<SignUpTeacherBody> createState() => _SignUpTeacherBodyState();
}

class _SignUpTeacherBodyState extends State<SignUpTeacherBody> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final governorateController = TextEditingController();
  final subjectController = TextEditingController();
  File? uploadedImageUrl;

  // File? _selectedImage;

  // Future<void> _pickImage() async {
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() {
  //       _selectedImage = File(picked.path);
  //     });
  //   }
  // }

  void _registerTeacher() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        role: UserRole.teacher,
        imageFile: uploadedImageUrl,
        phone: phoneController.text.trim(),
        governorate: governorateController.text.trim(),
        subject: subjectController.text.trim(),
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
      listener: (context, state) {
        if (state is Success) {
          ShowToast.showToastSuccessTop(
            message: context.translate(state.successMessage),
          );
          context.pushNamedAndRemoveUntil(AppRoutes.login);
        } else if (state is Failure) {
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
                  title: context.translate(LangKeys.createATeacherAccount),
                  description: context.translate(
                    LangKeys.completeYourAccountToStartLearning,
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
                SignUpTextFormTeacher(
                  namecontroller: nameController,
                  emailcontroller: emailController,
                  passwordcontroller: passwordController,
                  phonecontroller: phoneController,
                  governoratecontroller: governorateController,
                  formKey: _formKey, subjectcontroller: subjectController,
                ),

                SizedBox(
                  height: 20.h,
                ),
                //SignUpButton
                if (state is Loading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: ColorsLight.pinkLight,
                    ),
                  )
                else
                  SignUpButton(
                    onPressed: _registerTeacher,
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
