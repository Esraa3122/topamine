import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavItem extends StatelessWidget {
  const CustomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    super.key,
  });
  final IconData icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      decoration: isSelected
          ? BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            )
          : null,
      child: Icon(icon, size: 24),
    );
  }
}
