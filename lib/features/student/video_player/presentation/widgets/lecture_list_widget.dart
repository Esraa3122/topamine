import 'package:flutter/material.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
import 'package:test/features/student/home/data/model/lecture_model.dart';

class LectureListWidget extends StatelessWidget {
  const LectureListWidget({
    required this.course,
    required this.selectedLecture,
    required this.onLectureSelected,
    super.key,
  });

  final CourseModel course;
  final LectureModel selectedLecture;
  final Function(LectureModel) onLectureSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: course.lectures.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final lecture = course.lectures[index];
        final isCurrent = lecture.title == selectedLecture.title;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 212, 211, 211).withOpacity(0.8),
                Colors.white.withOpacity(0.8),
              ],
              begin: const Alignment(0.36, 0.27),
              end: const Alignment(0.58, 0.85),
            ),
            border: Border.all(
              color: isCurrent ? Colors.blue : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            leading: Icon(
              Icons.play_circle_fill,
              color: isCurrent ? Colors.blue : Colors.grey,
              size: 30,
            ),
            title: Text(
              lecture.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isCurrent ? Colors.blue.shade800 : Colors.black,
              ),
            ),
            onTap: () => onLectureSelected(lecture),
          ),
        );
      },
    );
  }
}
