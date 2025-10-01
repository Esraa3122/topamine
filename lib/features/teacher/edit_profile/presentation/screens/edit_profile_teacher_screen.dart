import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';

class EditProfileTeacherScreen extends StatefulWidget {
  const EditProfileTeacherScreen({required this.user, super.key});
  final UserModel user;

  @override
  State<EditProfileTeacherScreen> createState() =>
      _EditProfileTeacherScreenState();
}

class _EditProfileTeacherScreenState extends State<EditProfileTeacherScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController governorateController;
  late TextEditingController phoneNumberController;
  late TextEditingController subjectController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.userName);
    emailController = TextEditingController(text: widget.user.userEmail);
    governorateController = TextEditingController(
      text: widget.user.governorate,
    );
    phoneNumberController = TextEditingController(text: widget.user.phone);
    subjectController = TextEditingController(
      text: widget.user.subject,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    governorateController.dispose();
    phoneNumberController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    String? imageUrl = widget.user.userImage;

    if (selectedImage != null) {
      imageUrl = await sl<AuthRepos>().uploadProfileImage(selectedImage!);
    }

    final updatedUser = widget.user.copyWith(
      userName: nameController.text,
      userEmail: emailController.text,
      userImage: imageUrl,
      governorate: governorateController.text,
      phone: phoneNumberController.text,
      subject: subjectController.text,
    );
    await sl<AuthRepos>().updateUserData(updatedUser);

    Navigator.pop(context, updatedUser);
  }

  File? selectedImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextApp(
          text: context.translate(LangKeys.editProfile),
          theme: const TextStyle(
            fontWeight: FontWeightHelper.bold,
            fontFamily: FontFamilyHelper.cairoArabic,
            fontSize: 22,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.color.bluePinkLight,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                context.color.bluePinkLight!,
                context.color.bluePinkDark!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 60.h,),
            Hero(
              tag: 'profile-image',
              child: GestureDetector(
                onTap: pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage!)
                          : (widget.user.userImage != null &&
                                  widget.user.userImage!.isNotEmpty
                              ? NetworkImage(widget.user.userImage!)
                              : const AssetImage(
                                  AppImages.userAvatar,
                                )) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
      
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: child,
                );
              },
              child: Container(
                key: ValueKey(selectedImage), 
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: context.color.mainColor,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        lable: context.translate(LangKeys.name),
                      ),
                      SizedBox(height: 15.h),
                      CustomTextField(
                        controller: emailController,
                        lable: context.translate(LangKeys.email),
                      ),
                      SizedBox(height: 15.h),
                       CustomTextField(
                      controller: phoneNumberController,
                      lable: 'رقم الهاتف',
                    ),
                     SizedBox(height: 15.h),
                     CustomTextField(
                      controller: subjectController,
                      lable: 'الماده',
                    ),
                      SizedBox(height: 15.h),
                      CustomTextField(
                        controller: governorateController,
                        lable: 'المحافظة',
                      ),
                      SizedBox(height: 25.h),
                      CustomLinearButton(
                        onPressed: _saveChanges,
                        child: TextApp(
                          text: 'حفظ التغييرات',
                          theme: context.textStyle.copyWith(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeightHelper.bold,
                            fontFamily: FontFamilyHelper.cairoArabic,
                            letterSpacing: 0.5
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  //   Scaffold(
  //     appBar: CustomAppBar(
  //       title: 'تعديل الملف الشخصي',
  //       color: context.color.textColor,
  //       backgroundColor: context.color.navBarbg,
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 20.w),
  //       child: Center(
  //         child: Container(
  //           // height: MediaQuery.of(context).size.height,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //             // border: Border.all(color: context.color.mainColor!),
  //             borderRadius: BorderRadius.circular(20.r),
  //             gradient: LinearGradient(
  //               colors: [
  //                 context.color.mainColor!.withOpacity(0.8),
  //                 context.color.mainColor!.withOpacity(0.8),
  //               ],
  //               begin: const Alignment(0.36, 0.27),
  //               end: const Alignment(0.58, 0.85),
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.3),
  //                 offset: const Offset(0, 4),
  //                 blurRadius: 2,
  //               ),
  //               BoxShadow(
  //                 color: context.color.containerShadow2!.withOpacity(0.3),
  //                 offset: const Offset(0, 4),
  //                 blurRadius: 2,
  //               ),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20),
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: [
  //                   GestureDetector(
  //                     onTap: pickImage,
  //                     child: Stack(
  //   alignment: Alignment.center,
  //   children: [
  //     CircleAvatar(
  //       radius: 50,
  //       backgroundImage: selectedImage != null
  //           ? FileImage(selectedImage!)
  //           : (widget.user.userImage != null &&
  //                   widget.user.userImage!.isNotEmpty
  //               ? NetworkImage(widget.user.userImage!)
  //               : const AssetImage('assets/images/core/user.png'))
  //               as ImageProvider,
  //       ),
  //       Positioned(
  //         bottom: 0,
  //         right: 0,
  //         child: Container(
  //           padding: const EdgeInsets.all(6),
  //           decoration: BoxDecoration(
  //             color: Colors.blue,
  //             shape: BoxShape.circle,
  //             border: Border.all(
  //               color: Colors.white,
  //               width: 2,
  //             ),
  //           ),
  //           child: const Icon(
  //             Icons.camera_alt,
  //             color: Colors.white,
  //             size: 20,
  //           ),
  //         ),
  //       ),
  //     ],
  //   ),
  // ),
  //                   SizedBox(height: 20.h),
  //                   CustomTextField(
  //                     controller: nameController,
  //                     lable: 'الاسم',
  //                   ),
  //                   SizedBox(height: 10.h),
  //                   CustomTextField(
  //                     controller: emailController,
  //                     lable: 'البريد',
  //                   ),
  //                   SizedBox(height: 10.h),

  //                   CustomTextField(
  //                     controller: phoneNumberController,
  //                     lable: 'رقم الهاتف',
  //                   ),
  //                   SizedBox(height: 10.h),
  //                   CustomTextField(
  //                     controller: governorateController,
  //                     lable: 'المحافظه',
  //                   ),
  //                   SizedBox(height: 10.h),
  //                   CustomTextField(
  //                     controller: subjectController,
  //                     lable: 'الماده',
  //                   ),
  //                   SizedBox(height: 20.h),
  //                   CustomLinearButton(
  //                     onPressed: _saveChanges,
  //                     child: const Text('حفظ'),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  }
}
