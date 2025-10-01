import 'package:flutter/material.dart';

class BookingCategoryModel {
  BookingCategoryModel({
    required this.name,
    required this.value,
    this.isSelected = false,
    this.color,
    this.gradient,
  });

  final String name;
  final String value;
  bool isSelected;

  /// لو فلتر بلون واحد
  final Color? color;

  /// لو فلتر بجريدينت
  final Gradient? gradient;
}
