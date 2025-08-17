import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/student/video_player/presentation/widgets/lecture_list_widget.dart';
import 'package:test/features/student/video_player/presentation/widgets/rating_dialog.dart';
import 'package:test/features/student/video_player/presentation/widgets/rating_tab_widget.dart';
import 'package:test/features/student/video_player/presentation/widgets/video_player_widget.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    required this.course,
    this.initialLecture,
    super.key,
  });

  final CoursesModel course;
  final LectureModel? initialLecture;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late LectureModel selectedLecture;

  @override
  void initState() {
    super.initState();
    if (widget.initialLecture != null) {
      selectedLecture = widget.initialLecture!;
    } else if (widget.course.lectures != null &&
        widget.course.lectures!.isNotEmpty) {
      selectedLecture = widget.course.lectures!.first;
    } else {
      selectedLecture = LectureModel(
        title: 'لا توجد محاضرات',
        videoUrl: '',
        txtUrl: '',
        docUrl: '',
      );
    }
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  void _changeLecture(LectureModel lecture) {
    setState(() => selectedLecture = lecture);
  }

  void _handleVideoCompleted() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final enrollmentQuery = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('courseId', isEqualTo: widget.course.id)
        .where('userId', isEqualTo: currentUserId) 
        .limit(1)
      .get();

  if (enrollmentQuery.docs.isEmpty) return;

  final doc = enrollmentQuery.docs.first;
  final data = doc.data();

  List<String> watchedVideos = [];

if (data['watchedVideos'] != null && data['watchedVideos'] is List) {
  watchedVideos = List<String>.from(data['watchedVideos'] as List);
}

final lectureKey = selectedLecture.videoUrl ?? '';

if (!watchedVideos.contains(lectureKey) && lectureKey.isNotEmpty) {
  watchedVideos.add(lectureKey);
}

final totalLectures = widget.course.lectures?.length ?? 1;
double progress = watchedVideos.length / totalLectures;

String status = progress >= 1.0 ? 'completed' : 'inProgress';

await doc.reference.update({
  'watchedVideos': watchedVideos,
  'progress': progress,
  'statusProgress': status,
});
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          _tabController.index == 1 &&
              selectedLecture.title != 'لا توجد محاضرات'
          ? FloatingActionButton(
              onPressed: () => showRatingDialog(
                context,
                selectedLecture.title,
              ),
              tooltip: 'أضف تقييم',
              backgroundColor: context.color.mainColor,
              child: const Icon(Icons.rate_review),
            )
          : null,
      appBar: CustomAppBar(
        title: context.translate(LangKeys.videoPlayer),
        color: context.color.textColor,
        backgroundColor: context.color.mainColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              child: VideoPlayerWidget(
  videoUrl: selectedLecture.videoUrl,
  onVideoCompleted: _handleVideoCompleted,
),
            ),
          ),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey.shade800,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            tabs: const [
              Tab(text: 'المحاضرات'),
              Tab(text: 'الآراء'),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _tabController.index == 0
                    ? LectureListWidget(
                        course: widget.course,
                        selectedLecture: selectedLecture,
                        onLectureSelected: _changeLecture,
                      )
                    : RatingTabWidget(
                        key: ValueKey(selectedLecture.title),
                        lectureTitle: selectedLecture.title,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
