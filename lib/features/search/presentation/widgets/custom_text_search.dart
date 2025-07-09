import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';

class CustomTextSearch extends StatelessWidget {
  const CustomTextSearch({
    required this.searchController, super.key,
    this.onChanged,
  });
  final void Function(String?)? onChanged;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: searchController,
      lable: 'Search',
      hintText: 'Search teacher or subject',
      prefixIcon: const Icon(Icons.search),
      suffixIcon: const Icon(Icons.filter_list),
      onChanged: onChanged,
    );
  }
}
