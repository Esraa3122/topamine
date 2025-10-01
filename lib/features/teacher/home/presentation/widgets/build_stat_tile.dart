import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    required this.title,
    required this.icon,
    required this.text,
    required this.color,
    super.key,
  });
  final String title;
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.color.mainColor,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: color.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(
              icon,
              color: color,
              size: 27,
            ),
          ),
          const SizedBox(height: 12),
          TextApp(
            text: text,
            theme: context.textStyle.copyWith(
              fontSize: 18,
              fontWeight: FontWeightHelper.bold,
              color: color,
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5
            ),
          ),
          const SizedBox(height: 6),
          TextApp(
            text: title,
            theme: context.textStyle.copyWith(
              fontSize: 13,
              fontWeight: FontWeightHelper.medium,
              fontFamily: FontFamilyHelper.cairoArabic,
              letterSpacing: 0.5
            ),
          ),
        ],
      ),
    );
  }
}
