import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VertiDivider extends StatelessWidget {
  const VertiDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 40.h, width: 1.2.w, color: Colors.grey[300]);
  }
}
