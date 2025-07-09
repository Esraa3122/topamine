import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectFilterList extends StatelessWidget {

  const SubjectFilterList({
    required this.selectedSubject, required this.onSubjectSelected, super.key,
    this.subjects = const [
      'All',
      'Mathematics',
      'English',
      'Science',
      'History',
      'Art'
    ],
  });
  final List<String> subjects;
  final String selectedSubject;
  final ValueChanged<String> onSubjectSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          final isSelected = selectedSubject == subject;

          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: GestureDetector(
              onTap: () => onSubjectSelected(subject),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.w),
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
