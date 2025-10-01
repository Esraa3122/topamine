import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/style/color/colors_dark.dart';
import 'package:test/core/style/color/colors_light.dart';
import 'package:test/features/student/booking/data/model/categorey_booking_model.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_category_chip.dart';

class CategoryBookingListStudent extends StatefulWidget {
  const CategoryBookingListStudent({
    required this.onFilterChanged,
    super.key,
  });
  // ignore: inference_failure_on_function_return_type
  final Function(String value) onFilterChanged;

  @override
  State<CategoryBookingListStudent> createState() => _CategoryBookingListState();
}

class _CategoryBookingListState extends State<CategoryBookingListStudent> {
  List<BookingCategoryModel> filters = [
    BookingCategoryModel(
      name: 'الكل',
      value: 'all',
      isSelected: true,
      gradient: const LinearGradient(
        colors: [ ColorsLight.pinkLight, ColorsDark.blueDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    BookingCategoryModel(
      name: 'مكتمل',
      value: 'completed',
      color: Colors.green,
      gradient: LinearGradient(
        colors: [ Colors.greenAccent.shade400, Colors.green.shade700],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    BookingCategoryModel(
      name: 'فى تقدم',
      value: 'inprogress',
      color: Colors.orange,
       gradient: LinearGradient(
        colors: [Colors.orange.shade300, Colors.deepOrange.shade600],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  void selectFilter(int selectedIndex) {
    setState(() {
      for (var i = 0; i < filters.length; i++) {
        filters[i].isSelected = i == selectedIndex;
      }
    });
    widget.onFilterChanged(filters[selectedIndex].value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return BookingCategoryChip(
            label: filter.name,
            isSelected: filter.isSelected,
            onTap: () => selectFilter(index),
            color: filter.color,
            gradient: filter.gradient,
          );
        },
      ),
    );
  }
}
