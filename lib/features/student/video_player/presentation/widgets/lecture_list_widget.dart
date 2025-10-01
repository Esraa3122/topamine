import 'package:flutter/material.dart';
import 'package:test/features/student/video_player/presentation/widgets/lec_card.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class LectureListWidget extends StatelessWidget {
  const LectureListWidget({
    required this.course,
    required this.selectedLecture,
    required this.onLectureSelected,
    required this.watchedVideos,
    super.key,
  });

  final CoursesModel course;
  final LectureModel selectedLecture;
  // ignore: inference_failure_on_function_return_type
  final Function(LectureModel) onLectureSelected;
  final List<String> watchedVideos;

  @override
  Widget build(BuildContext context) {
    final lectures = course.lectures ?? [];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: lectures.length,
      itemBuilder: (context, index) {
        final lecture = lectures[index];
        final isCurrent = lecture.videoUrl == selectedLecture.videoUrl;
        final isWatched = watchedVideos.contains(lecture.videoUrl);

        return LectureCard(
          lecture: lecture,
          index: index,
          isSelected: isCurrent,
          isCompleted: isWatched,
          onVideoTap: () {
            onLectureSelected(lecture);
          },
        );
      },
    );
  }
}
