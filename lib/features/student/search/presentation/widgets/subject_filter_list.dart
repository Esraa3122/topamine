import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectFilterList extends StatelessWidget {
  const SubjectFilterList({
    required this.sections,
    required this.selectedSubject,
    required this.onSubjectSelected,
    super.key,
  });
  final List<String> sections;
  final String selectedSubject;
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
                  color: isSelected ? Colors.blue : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  subject,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
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
