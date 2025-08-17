import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/video_player/cubit/video_cubit.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ItemLecteurTeacher extends StatefulWidget {
  const ItemLecteurTeacher({
    required this.lecture,
    required this.course,
    super.key,
  });

  final LectureModel lecture;
  final CoursesModel course;

  @override
  State<ItemLecteurTeacher> createState() => _ItemLecteurTeacherState();
}

class _ItemLecteurTeacherState extends State<ItemLecteurTeacher> {
  bool _isExpanded = false;

  bool get _isLocked {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;

  if (currentUserId != null && currentUserId == widget.course.teacherId) {
    return false;
  }

  return true;
}

  void _handleTapExpansion() {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الاشتراك لعرض محتوى المحاضرة')),
      );
      return;
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _handleVideoTap() {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الاشتراك لعرض الفيديو')),
      );
      return;
    }
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
  }

  void _handleDocTap(String url, String type) {
    if (_isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى الاشتراك لعرض $type')),
      );
      return;
    }
    launchUrlString(url);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: context.color.mainColor,
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
            title: TextApp(
              text: widget.lecture.title,
              theme: context.textStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeightHelper.medium,
                color: context.color.textColor,
              ),
            ),
            trailing: _isLocked
                ? const Icon(Icons.lock, color: Colors.grey)
                : Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
            onTap: _handleTapExpansion,
          ),
          SizedBox(
            width: double.infinity,
            child: AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.play_arrow, color: Colors.green),
                    title: TextApp(
                      text: 'مشاهدة الفيديو',
                      theme: context.textStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeightHelper.medium,
                        color: context.color.textColor,
                      ),
                    ),
                    onTap: _handleVideoTap,
                  ),
                  if ((widget.lecture.docUrl ?? '').isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: TextApp(
                        text: 'عرض PDF',
                        theme: context.textStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeightHelper.medium,
                          color: context.color.textColor,
                        ),
                      ),
                      onTap: () => _handleDocTap(widget.lecture.docUrl!, 'ملف PDF'),
                    ),
                  if ((widget.lecture.txtUrl ?? '').isNotEmpty)
                    ListTile(
                      leading: const Icon(Icons.description, color: Colors.orange),
                      title: TextApp(
                        text: 'عرض TXT',
                        theme: context.textStyle.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeightHelper.medium,
                          color: context.color.textColor,
                        ),
                      ),
                      onTap: () => _handleDocTap(widget.lecture.txtUrl!, 'ملف TXT'),
                    ),
                ],
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}

