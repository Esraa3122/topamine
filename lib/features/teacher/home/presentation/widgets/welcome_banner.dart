import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(2, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: context.translate(LangKeys.welcomeBack),
              theme: context.textStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeightHelper.bold,
                color: Colors.white,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            TextApp(
              text: context.translate(LangKeys.readyToManageYourCourses),
              theme: context.textStyle.copyWith(
                fontSize: 14,
                color: Colors.white70,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
