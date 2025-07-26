import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';
import 'package:test/features/student/video_player/cubit/video_cubit.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LectureItem extends StatelessWidget {
  const LectureItem({required this.course, super.key});
  // final LectureModel lecture;
  final CoursesModel course;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(
          Icons.play_circle_fill,
          color: Colors.blue,
          size: 30,
        ),
        title: TextApp(
          text: course.lecturesModel!.title,
          theme: context.textStyle.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextApp(
              text: course.lecturesModel!.videoUrl,
              theme: context.textStyle.copyWith(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            if (course.lecturesModel!.pdfUrl.isNotEmpty)
              TextButton(
                onPressed: () {
                  launchUrlString(course.lecturesModel!.pdfUrl);
                },
                child: const Text('عرض PDF'),
              ),
            if (course.lecturesModel!.txtUrl.isNotEmpty)
              TextButton(
                onPressed: () {
                  launchUrlString(course.lecturesModel!.txtUrl);
                },
                child: const Text('عرض TXT'),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (_) => VideoCubit(),
                child: VideoPlayerPage(
                  course: course,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
