import 'package:flutter/material.dart';

class CustomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const CustomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
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
