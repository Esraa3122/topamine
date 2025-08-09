import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/student/video_player/cubit/video_cubit.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LectureItem extends StatefulWidget {
  const LectureItem({
    required this.lecture,
    required this.course,
    super.key,
  });

  final LectureModel lecture;
  final CoursesModel course;

  @override
  State<LectureItem> createState() => _LectureItemState();
}

class _LectureItemState extends State<LectureItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey[300],
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.play_circle_fill,
              color: Colors.blue,
              size: 30,
            ),
            title: Text(
              widget.lecture.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.grey,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.play_arrow, color: Colors.green),
                  title: const Text('مشاهدة الفيديو'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (_) => VideoCubit(),
                          child: VideoPlayerPage(
                            course: widget.course,
                            initialLecture: widget.lecture,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // PDF
                if ((widget.lecture.docUrl ?? '').isNotEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                    title: const Text('عرض PDF'),
                    onTap: () {
                      launchUrlString(widget.lecture.docUrl!);
                    },
                  ),
                if ((widget.lecture.txtUrl ?? '').isNotEmpty)
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.orange,
                    ),
                    title: const Text('عرض TXT'),
                    onTap: () {
                      launchUrlString(widget.lecture.txtUrl!);
                    },
                  ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}