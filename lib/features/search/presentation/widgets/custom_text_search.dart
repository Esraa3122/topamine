import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';

class CustomTextSearch extends StatelessWidget {
  const CustomTextSearch({
    required this.searchController, super.key,
    this.onChanged,
  });
  final String? Function(String?)? onChanged;
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

    //  TextField(
    //   onChanged: onChanged,
    //   decoration: InputDecoration(
    //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    //     filled: true,
    //     fillColor: const Color(0xffF3F4F6),
    //     labelText: label,
    //     prefixIcon: const Icon(Icons.search),
    //     suffixIcon: suffixIcon,
    //   ),
    // );
  }
}
