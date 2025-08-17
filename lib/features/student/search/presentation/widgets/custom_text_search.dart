import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';

class CustomTextSearch extends StatelessWidget {
  const CustomTextSearch({
    required this.searchController,
    super.key,
    this.onSubmitted,
  });
  final TextEditingController searchController;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: searchController,
      lable: context.translate(LangKeys.search),
      hintText: context.translate(LangKeys.searchForTeacherOrsubject),
      prefixIcon: const Icon(Icons.search),
      suffixIcon: const Icon(Icons.filter_list),
      onFieldSubmitted: onSubmitted,
    );
  }
}
