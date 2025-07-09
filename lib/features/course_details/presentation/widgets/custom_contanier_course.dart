import 'package:flutter/material.dart';

class CustomContanierCourse extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const CustomContanierCourse({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
      ),
      child: Text(label, style: TextStyle(color: textColor)),
    );
  }
}
