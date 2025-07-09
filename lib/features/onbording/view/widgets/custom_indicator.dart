import 'package:flutter/material.dart';
import 'package:test/core/style/color/colors_light.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({required this.active, super.key});
  final bool active;

  @override
  Widget build(BuildContext context) {
    return 
    AnimatedContainer(
      duration: const Duration(microseconds: 3500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: active?ColorsLight.pinkLight:ColorsLight.greyCFColor,
      ),
      width: active?10:8,
      height: active?10:8,
    );
  }
}
