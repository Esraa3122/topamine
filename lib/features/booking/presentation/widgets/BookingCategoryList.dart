import 'package:flutter/material.dart';

class BookingCategoryList extends StatelessWidget {
  final String selectedValue;
  // ignore: inference_failure_on_function_return_type
  final Function(String) onChanged;

  const BookingCategoryList({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<String> filters = const ['all', 'inprogress', 'completed'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onChanged(filter),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: selectedValue == filter ? Colors.blue : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  filter[0].toUpperCase() + filter.substring(1),
                  style: TextStyle(
                    color: selectedValue == filter ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
