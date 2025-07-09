import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_drop_down_button_form_field.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/utils/app_regex.dart';

class SignUpTextFormTeacher extends StatefulWidget {
  const SignUpTextFormTeacher({
    required this.namecontroller,
    required this.emailcontroller,
    required this.passwordcontroller,
    required this.phonecontroller,
    required this.governoratecontroller,
    required this.formKey,
    super.key,
  });
  final TextEditingController namecontroller;
  final TextEditingController emailcontroller;
  final TextEditingController passwordcontroller;
  final TextEditingController phonecontroller;
  final TextEditingController governoratecontroller;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpTextFormTeacher> createState() => _SignUpTextFormTeacherState();
}

class _SignUpTextFormTeacherState extends State<SignUpTextFormTeacher> {
  bool isShowPassword = true;
  String? selectedGender;
  String? selecteGovernorate;
  List<String> governorate = [
    'الإسكندرية',
    'الإسماعيلية',
    'أسوان',
    'أسيوط',
    'الأقصر',
    'الغردقة',
    'دمنهور',
    'بني سويف',
    'بورسعيد',
    'الطور',
    'الجيزة',
    'الدقهليه',
    'دمياط',
    'سوهاج',
    'السويس',
    'شمال سيناء	',
    'الشرقية',
    'الغربية',
    'الفيوم',
    'القاهرة',
    'القليوبية',
    'قنا',
    'كفر الشيخ',
    'مطروح',
    'المنوفية',
    'المنيا',
    'الوادي الجديد',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          // Name
          CustomFadeInRight(
            duration: 200,
            child: CustomTextField(
              controller: widget.namecontroller,
              hintText: context.translate(LangKeys.enterYourName),
              prefixIcon: const Icon(Icons.person),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 4) {
                  return context.translate(LangKeys.validName);
                } else {
                  return null;
                }
              },
              lable: context.translate(LangKeys.fullName),
            ),
          ),
          SizedBox(height: 20.h),

          // governorate
          CustomDropDownButtonFormField(
            selectedGender: selecteGovernorate,
            hintText: context.translate(LangKeys.governorate),
            items: governorate.map((String governorate) {
              return DropdownMenuItem(
                value: governorate,
                child: Text(governorate),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selecteGovernorate = newValue;

                widget.governoratecontroller.text = newValue ?? '';
              });
              return null;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.translate(LangKeys.pleaseSelectGovernorate);
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),

          // Email
          CustomFadeInRight(
            duration: 200,
            child: CustomTextField(
              controller: widget.emailcontroller,
              hintText: context.translate(LangKeys.enterYourEmailAddress),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email),
              validator: (value) {
                if (!AppRegex.isEmailValid(widget.emailcontroller.text)) {
                  return context.translate(LangKeys.validEmail);
                } else {
                  return null;
                }
              },
              lable: context.translate(LangKeys.email),
            ),
          ),
          SizedBox(height: 20.h),

          // Password
          CustomFadeInRight(
            duration: 200,
            child: CustomTextField(
              controller: widget.passwordcontroller,
              lable: context.translate(LangKeys.password),
              hintText: context.translate(LangKeys.enterYourPassword),
              keyboardType: TextInputType.visiblePassword,
              obscureText: isShowPassword,
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 6) {
                  return context.translate(LangKeys.validPassword);
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                icon: Icon(
                  isShowPassword ? Icons.visibility_off : Icons.visibility,
                  color: context.color.textColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),

          // Phone
          CustomFadeInRight(
            duration: 200,
            child: CustomTextField(
              controller: widget.phonecontroller,
              lable: context.translate(LangKeys.phone),
              hintText: context.translate(LangKeys.enterPhoneNumber),
              prefixIcon: const Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (!AppRegex.isPhoneValid(widget.phonecontroller.text)) {
                  return context.translate(LangKeys.pleaseEnterYourPhoneNumber);
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
