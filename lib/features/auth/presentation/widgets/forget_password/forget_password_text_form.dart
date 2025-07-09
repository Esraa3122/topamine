import 'package:flutter/material.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/utils/app_regex.dart';

class TextFildForgetPassword extends StatefulWidget {
  const TextFildForgetPassword({
    required this.emailcontroller, required this.formKey, super.key,
  });

 final TextEditingController emailcontroller;
 final GlobalKey<FormState> formKey;

  @override
  State<TextFildForgetPassword> createState() => _TextFildForgetPasswordState();
}

class _TextFildForgetPasswordState extends State<TextFildForgetPassword> {
  

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: CustomFadeInRight(
        duration: 200,
        child: CustomTextField(
          controller: widget.emailcontroller,
          hintText: context.translate(LangKeys.enterYourEmailAddress),
          prefixIcon: const Icon(Icons.email),
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
    );
  }
}
