import 'package:flutter/material.dart';
import 'package:test/core/style/fonts/styles.dart';

class PaymentItemInfo extends StatelessWidget {
  const PaymentItemInfo({required this.title, required this.value, super.key});
  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: Styles.style18,
        ),
        Text(
          value,
          style: Styles.styleBold18,
        ),
      ],
    );
  }
}
