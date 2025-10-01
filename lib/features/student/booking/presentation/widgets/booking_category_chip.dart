import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class BookingCategoryChip extends StatelessWidget {
  const BookingCategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.gradient,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final chipColor = isSelected
        ? color ?? context.color.bluePinkLight
        : Colors.transparent;
    final chipGradient = isSelected ? gradient : null;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: chipGradient,
            color: chipGradient == null ? chipColor : null,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (color ?? context.color.bluePinkLight)!,
            ),
          ),
          child: TextApp(
            text: label,
            theme: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (color ??
                        (gradient != null
                            ? (gradient!.colors.first)
                            : context.color.bluePinkLight)),
              fontWeight: FontWeightHelper.regular,
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
