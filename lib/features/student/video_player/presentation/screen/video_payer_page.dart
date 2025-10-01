import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
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
  String? userRole;
  List<String> watchedVideos = [];

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
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));

    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          userRole = snapshot['role'] as String?;
        });
      }

      if (widget.course.id != null) {
        final enrollmentQuery = await FirebaseFirestore.instance
            .collection('enrollments')
            .where('courseId', isEqualTo: widget.course.id)
            .where('userId', isEqualTo: uid)
            .limit(1)
            .get();

        if (enrollmentQuery.docs.isNotEmpty) {
          final data = enrollmentQuery.docs.first.data();
          final watched = data['watchedVideos'];
          if (watched is List) {
            setState(() {
              watchedVideos = watched.map((e) => e.toString()).toList();
            });
          }
        }
      }
    }
  }

  void _changeLecture(LectureModel lecture) {
    setState(() => selectedLecture = lecture);
  }

  Future<void> _handleVideoCompleted() async {
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

    if (data['watchedVideos'] != null && data['watchedVideos'] is List) {
      watchedVideos = List<String>.from(data['watchedVideos'] as List<dynamic>);
    }

    final lectureKey = selectedLecture.videoUrl;
    if (!watchedVideos.contains(lectureKey) && lectureKey.isNotEmpty) {
      watchedVideos.add(lectureKey);
    }

    final totalLectures = widget.course.lectures?.length ?? 1;
    final progress = watchedVideos.length / totalLectures;
    final status = progress >= 1.0 ? 'completed' : 'inProgress';

    await doc.reference.update({
      'watchedVideos': watchedVideos,
      'progress': progress,
      'statusProgress': status,
    });

    setState(() {});
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
              widget.course.id != null &&
              userRole != 'teacher'
          ? FloatingActionButton(
              onPressed: () => showRatingDialog(
                context,
                widget.course.id!,
              ),
              tooltip: 'أضف تقييم',
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              elevation: 4,
              child: Container(
                constraints: const BoxConstraints.expand(),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      context.color.bluePinkLight!,
                      context.color.bluePinkDark!,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.rate_review, color: Colors.white),
              ),
            )
          : null,
      appBar: AppBar(
        title: TextApp(
          text: context.translate(LangKeys.videoPlayer),
          theme: context.textStyle.copyWith(
            fontWeight: FontWeightHelper.bold,
            fontSize: 22,
            color: Colors.white,
            fontFamily: FontFamilyHelper.cairoArabic,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.color.bluePinkLight,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                context.color.bluePinkLight!,
                context.color.bluePinkDark!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: VideoPlayerWidget(
                  videoUrl: selectedLecture.videoUrl,
                  onVideoCompleted: _handleVideoCompleted,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
                       title: TextApp(
               text: widget.course.title,
               theme: context.textStyle.copyWith(
                 fontWeight: FontWeightHelper.bold,
                 fontSize: 16,
                 fontFamily: FontFamilyHelper.cairoArabic,
                 letterSpacing: 0.5,
               ),
             ),
                       subtitle: TextApp(
               text: widget.course.teacherName,
               theme: context.textStyle.copyWith(
                fontWeight: FontWeightHelper.regular,
                 fontFamily: FontFamilyHelper.cairoArabic,
                 letterSpacing: 0.5,
               ),
             ),
                     ),
          ),
          // MemoWidget(
          //   pdfUrl: selectedLecture.docUrl,
          //   textMemo: selectedLecture.txtUrl,
          // ),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.blueAccent,
            indicatorWeight: 3,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey.shade500,
            tabs: const [
              Tab(icon: Icon(Icons.video_library), text: 'المحاضرات'),
              Tab(icon: Icon(Icons.reviews), text: 'الآراء'),
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
                        watchedVideos: watchedVideos,
                        onLectureSelected: _changeLecture,
                      )
                    : RatingTabWidget(
                        key: ValueKey(widget.course.id),
                        courseId: widget.course.id!,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
