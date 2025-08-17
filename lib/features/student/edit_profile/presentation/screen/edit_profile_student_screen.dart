import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';

class EditProfileStudentScreen extends StatefulWidget {
  const EditProfileStudentScreen({required this.user, super.key});
  final UserModel user;

  @override
  State<EditProfileStudentScreen> createState() =>
      _EditProfileStudentScreenState();
}

class _EditProfileStudentScreenState extends State<EditProfileStudentScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController academicYearController;
  late TextEditingController governorateController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.user.userName);
    emailController = TextEditingController(text: widget.user.userEmail);
    // passwordController = TextEditingController();
    academicYearController = TextEditingController(
      text: widget.user.grade,
    );
    governorateController = TextEditingController(
      text: widget.user.governorate,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
      String? imageUrl = widget.user.userImage;

  if (selectedImage != null) {
    imageUrl = await sl<AuthRepos>().uploadProfileImage(selectedImage!);
  }

    final updatedUser = widget.user.copyWith(
      userName: nameController.text,
      userEmail: emailController.text,
      userImage: imageUrl,
      grade: academicYearController.text,
      governorate: governorateController.text,
    );
    await sl<AuthRepos>().updateUserData(updatedUser);

    Navigator.pop(context, updatedUser);
  }
  File? selectedImage;

Future<void> pickImage() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      selectedImage = File(pickedFile.path);
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'تعديل الملف الشخصي',
        color: context.color.textColor,
        backgroundColor: context.color.navBarbg,
      ),
      body:Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              colors: [
                context.color.mainColor!.withOpacity(0.8),
                context.color.mainColor!,
              ],
              begin: const Alignment(0.36, 0.27),
              end: const Alignment(0.58, 0.85),
            ),
            boxShadow: [
              BoxShadow(
                color: context.color.containerShadow1!.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 2,
              ),
               BoxShadow(
                color: context.color.bluePinkLight!.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                radius: 50,
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : (widget.user.userImage != null && widget.user.userImage!.isNotEmpty
                ? NetworkImage(widget.user.userImage!)
                : const AssetImage('assets/images/core/user.png')),
              ),
              
              ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    controller: nameController,
                    lable: 'الاسم',
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: emailController,
                    lable: 'البريد',
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: academicYearController,
                    lable: 'السنه الدراسيه',
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    controller: governorateController,
                    lable: 'المحافظه',
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(height: 20.h),
                  CustomLinearButton(
                    onPressed: _saveChanges,
                    child: const Text('حفظ'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),)
    );
  }
}
