import 'package:flutter/widgets.dart';
import 'package:test/core/style/fonts/styles.dart';

class CustomButton3 extends StatelessWidget {
  const CustomButton3({
    required this.text, super.key,
    this.onTap,
  });

  final void Function()? onTap;

  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: ShapeDecoration(
          color: const Color(0xFF34A853),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Styles.style22,
          ),
        ),
      ),
    );
  }
}
