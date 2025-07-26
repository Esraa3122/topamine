import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';
import 'package:test/features/student/video_player/presentation/widgets/lecture_list_widget.dart';
import 'package:test/features/student/video_player/presentation/widgets/rating_dialog.dart';
import 'package:test/features/student/video_player/presentation/widgets/rating_tab_widget.dart';
import 'package:test/features/student/video_player/presentation/widgets/video_player_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    required this.course,
    super.key,
  });

  final CoursesModel course;

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
    if (widget.course.lectures != null && widget.course.lectures!.isNotEmpty) {
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _tabController.index == 1
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
          VideoPlayerWidget(videoUrl: selectedLecture.videoUrl),
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
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: IndexedStack(
                  key: ValueKey<int>(_tabController.index),
                  index: _tabController.index,
                  children: [
                    LectureListWidget(
                      course: widget.course,
                      selectedLecture: selectedLecture,
                      onLectureSelected: _changeLecture,
                    ),
                    RatingTabWidget(lectureTitle: selectedLecture.title),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
