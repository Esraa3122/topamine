class BookingCategoryModel {

  BookingCategoryModel({
    required this.name,
    required this.value,
    this.isSelected = false,
  });
  final String name;
  final String value;
  bool isSelected;
}
