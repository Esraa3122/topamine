class BookingCategoryModel {
  final String name;
  final String value;
  bool isSelected;

  BookingCategoryModel({
    required this.name,
    required this.value,
    this.isSelected = false,
  });
}
