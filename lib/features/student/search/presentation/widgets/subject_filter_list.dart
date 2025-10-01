import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class SubjectFilterList extends StatelessWidget {
  const SubjectFilterList({
    required this.sections,
    required this.selectedSubject,
    required this.onSubjectSelected,
    super.key,
  });

  final List<String> sections;
  final String selectedSubject;
  // ignore: inference_failure_on_function_return_type
  final Function(String) onSubjectSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final subject = sections[index];
          final isSelected = selectedSubject == subject;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onSubjectSelected(subject),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 10.h,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            context.color.bluePinkLight!,
                            context.color.bluePinkDark!, 
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : context.color.bluePinkLight!,
                  ),
                ),
                child: TextApp(
                  text: subject,
                  theme: TextStyle(
                    color: isSelected ? Colors.white : context.color.textColor,
                    fontWeight: FontWeightHelper.regular,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
