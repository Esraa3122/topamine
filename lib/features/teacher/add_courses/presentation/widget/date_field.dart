import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';

class DateField extends StatelessWidget {
  const DateField({required this.label, required this.date, super.key});
  final String label;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: context.color.textFormBorder!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextApp(
            text: label, 
            theme: context.textStyle.copyWith(
              fontSize: 12,
              color: context.color.textColor!.withOpacity(0.5),
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          TextApp(
            text: date != null
                ? DateFormat('yyyy-MM-dd').format(date!)
                : 'اختر التاريخ',
            theme: context.textStyle.copyWith(
              fontSize: 14,
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5,
              ),
          ),
        ],
      ),
    );
  }
}

