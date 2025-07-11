import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingStatusListTeacher extends StatelessWidget {
  const BookingStatusListTeacher({
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });
  final String selectedValue;
  // ignore: inference_failure_on_function_return_type
  final Function(String) onChanged;

  final List<String> filters = const [
    'all',
    'الصف الاول الثانوى',
    'الصف الثانى الثانوى',
    'الصف الثالث الثانوى',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  color: selectedValue == filter
                      ? Colors.blue
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  filter[0].toUpperCase() + filter.substring(1),
                  style: TextStyle(
                    color: selectedValue == filter
                        ? Colors.white
                        : Colors.black87,
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
