import 'package:flutter/material.dart';
import 'package:test/core/style/fonts/styles.dart';

class OrderInfoItem extends StatelessWidget {
  const OrderInfoItem({required this.title, required this.value, super.key});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Styles.style18,
        ),
        const Spacer(),
        Text(
          value,
          textAlign: TextAlign.center,
          style: Styles.style18,
        ),
      ],
    );
  }
}
