import 'package:flutter/material.dart';

class DotedSplash extends StatelessWidget {
  const DotedSplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 1 ? Colors.white : Colors.white54,
          ),
        );
      }),
    );
  }
}
