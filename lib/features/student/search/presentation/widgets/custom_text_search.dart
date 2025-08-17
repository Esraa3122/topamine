import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';

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
      lable: 'البحث',
      hintText: 'البحث عن معلم أو مادة',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: const Icon(Icons.filter_list),
      onFieldSubmitted: onSubmitted,
    );
  }
}
