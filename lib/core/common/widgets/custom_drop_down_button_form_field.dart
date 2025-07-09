import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';

class CustomDropDownButtonFormField extends StatelessWidget {
  const CustomDropDownButtonFormField({
    required this.items, super.key,
    this.validator,
    this.hintText,
    this.hintStyle,
    this.onChanged, this.selectedGender,
  });
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final List<DropdownMenuItem<String>>? items;
  final String? hintText;
  final TextStyle? hintStyle;
  final String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: context.color.textColor,
      ),
      validator: (value) {
        return validator!(value);
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.color.textFormBorder!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: context.color.textFormBorder!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      value: selectedGender,
      hint: Text(
        hintText!,
        style:
            hintStyle ??
            context.textStyle.copyWith(
              color: context.color.textColor,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
      ),
      isExpanded: true,
      items: items,
    );
  }
}
