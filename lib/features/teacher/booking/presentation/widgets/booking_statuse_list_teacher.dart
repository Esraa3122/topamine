import 'package:flutter/material.dart';
import 'package:test/features/teacher/booking/presentation/widgets/category_booking_list_teacher.dart';

class BookingStatusListTeacher extends StatelessWidget {
  const BookingStatusListTeacher({
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });
  final String selectedValue;
  // ignore: inference_failure_on_function_return_type
  final Function(String) onChanged;

  // ignore: avoid_field_initializers_in_const_classes
  final List<String> filters = const [
    'all',
    'active',
    'not active',
  ];

  @override
  Widget build(BuildContext context) {
    return CategoryBookingListTeacher(
      onFilterChanged: onChanged,
    );
  }
}
