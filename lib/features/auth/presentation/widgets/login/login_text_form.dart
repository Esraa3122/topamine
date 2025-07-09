import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/utils/app_regex.dart';

class LoginTextForm extends StatefulWidget {
  const LoginTextForm({
    required this.emailcontroller,
    required this.passwordcontroller,
    required this.formKey,
    super.key, 
  });
  final TextEditingController emailcontroller;
  final TextEditingController passwordcontroller;
  final GlobalKey<FormState> formKey;


  @override
  State<LoginTextForm> createState() => _LoginTextFormState();
}

class _LoginTextFormState extends State<LoginTextForm> {
  bool isShowPassword = true;

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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: widget.formKey,
      child: Column(
        children: [
          // Email
          CustomFadeInRight(
            duration: 200,
            child: CustomTextField(
              controller: widget.emailcontroller,
              prefixIcon: const Icon(Icons.email),
              hintText: context.translate(LangKeys.enterYourEmailAddress),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!AppRegex.isEmailValid(widget.emailcontroller.text)) {
                  return context.translate(LangKeys.validEmail);
                } else {
                  return null;
                }
              }, lable: context.translate(LangKeys.email),
            ),
          ),
          SizedBox(height: 25.h),
      
          // Password
          CustomFadeInRight(
            duration: 200,
            child: CustomTextField(
              controller: widget.passwordcontroller,
              hintText: context.translate(LangKeys.enterYourPassword),
              keyboardType: TextInputType.visiblePassword,
              obscureText: isShowPassword ,
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
              ), lable: context.translate(LangKeys.password),
            ),
          ),
        ],
      ),
    );
  }
}
