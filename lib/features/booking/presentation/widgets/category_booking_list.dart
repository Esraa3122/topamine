import 'package:flutter/material.dart';
import 'package:test/features/booking/data/model/categorey_booking_model.dart';
import 'package:test/features/booking/presentation/widgets/booking_category_chip.dart';

class CategoryBookingList extends StatefulWidget {
  // ignore: inference_failure_on_function_return_type
  final Function(String value) onFilterChanged;

  const CategoryBookingList({
    super.key,
    required this.onFilterChanged,
  });

  @override
  State<CategoryBookingList> createState() => _CategoryBookingListState();
}

class _CategoryBookingListState extends State<CategoryBookingList> {
  List<BookingCategoryModel> filters = [
    BookingCategoryModel(name: "All", value: "all", isSelected: true),
    BookingCategoryModel(name: "Completed", value: "completed"),
    BookingCategoryModel(name: "In Progress", value: "inprogress"),
  ];

  void selectFilter(int selectedIndex) {
    setState(() {
      for (int i = 0; i < filters.length; i++) {
        filters[i].isSelected = i == selectedIndex;
      }
    });
    widget.onFilterChanged(filters[selectedIndex].value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return BookingCategoryChip(
            label: filter.name,
            isSelected: filter.isSelected,
            onTap: () => selectFilter(index),
          );
        },
      ),
    );
  }
}
