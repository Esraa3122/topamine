import 'package:flutter/material.dart';
import 'package:test/features/student/search/presentation/widgets/subject_filter_list.dart';

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({
    required this.gradeLevels,
    required this.subjects,
    required this.selectedGrade,
    required this.selectedSubject,
    required this.onGradeSelected,
    required this.onSubjectSelected,
    super.key,
  });
  final List<String> gradeLevels;
  final List<String> subjects;
  final String selectedGrade;
  final String selectedSubject;
  final ValueChanged<String> onGradeSelected;
  final ValueChanged<String> onSubjectSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SubjectFilterList(
          sections: gradeLevels,
          selectedSubject: selectedGrade,
          onSubjectSelected: onGradeSelected,
        ),
        const SizedBox(height: 20),
        SubjectFilterList(
          sections: subjects,
          selectedSubject: selectedSubject,
          onSubjectSelected: onSubjectSelected,
        ),
      ],
    );
  }
}
