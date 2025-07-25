import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/custom_app_bar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
import 'package:test/features/student/home/data/model/lecture_model.dart';
import 'package:test/features/student/video_player/presentation/widgets/lecture_list_widget.dart';
import 'package:test/features/student/video_player/presentation/widgets/rating_dialog.dart';
import 'package:test/features/student/video_player/presentation/widgets/rating_tab_widget.dart';
import 'package:test/features/student/video_player/presentation/widgets/video_player_widget.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    required this.lecture,
    required this.course,
    super.key,
  });

  final LectureModel lecture;
  final CourseModel course;

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
    selectedLecture = widget.lecture;
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
              child: const Icon(Icons.rate_review),
            )
          : null,
      appBar: CustomAppBar(
        title: context.translate(LangKeys.videoPlayer),
        color: context.color.textColor,
        backgroundColor: context.color.mainColor,
      ),
      body: Column(
        children: [
          VideoPlayerWidget(videoUrl: selectedLecture.videoUrl),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            onTap: (_) => setState(() {}),
            tabs: const [
              Tab(text: 'المحاضرات'),
              Tab(text: 'الآراء'),
            ],
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
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
        ],
      ),
    );
  }
}
