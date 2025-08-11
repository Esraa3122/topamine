import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/firebase/notifications/notification_helper.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/home/presentation/widgets/auto_slider.dart';
import 'package:test/features/student/home/presentation/widgets/course_for_you.dart';
import 'package:test/features/student/home/presentation/widgets/progress_badges.dart';
import 'package:test/features/student/home/presentation/widgets/teachers_list.dart';

class HomeStudentBody extends StatefulWidget {
  const HomeStudentBody({super.key});

  @override
  State<HomeStudentBody> createState() => _HomeStudentBodyState();
}

class _HomeStudentBodyState extends State<HomeStudentBody> {
  final TextEditingController searchController = TextEditingController();
  Set<String> notifiedCourseIds = {};
  // String searchQuery = '';
  @override
  void initState() {
    super.initState();
    loadNotifiedCourses();
    listenForNewCourses();
  }

  Future<void> loadNotifiedCourses() async {
    final prefs = SharedPref().getPreferenceInstance();
    final savedList = prefs.getStringList('notifiedCourses') ?? [];
    setState(() {
      notifiedCourseIds = savedList.toSet();
    });
  }

  void listenForNewCourses() {
    FirebaseFirestore.instance.collection('courses').snapshots().listen((
      snapshot,
    ) async {
      final prefs = SharedPref().getPreferenceInstance();
      for (final change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final courseId = change.doc.id;

          if (!notifiedCourseIds.contains(courseId)) {
            final course = change.doc.data();
            final courseTitle = course?['title'] ?? 'كورس جديد';
            await flutterLocalNotificationsPlugin.show(
              0,
              '📚 كورس جديد',
              'تم إضافة الكورس "$courseTitle" للتو!',
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'high_importance_channel',
                  'إشعارات مهمة',
                  importance: Importance.high,
                ),
              ),
              payload: courseId,
            );
            notifiedCourseIds.add(courseId);
            await prefs.setStringList(
              'notifiedCourses',
              notifiedCourseIds.toList(),
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BannerSliders(),
        SizedBox(height: 20.h),
        // CategoryList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextApp(
              text: context.translate(LangKeys.coursesForYou),
              theme: context.textStyle.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(AppRoutes.allCoursesPage);
              },
              child: TextApp(
                text: context.translate(LangKeys.viewAll),
                theme: context.textStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: context.color.bluePinkLight,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        const CoursesListYou(),
        SizedBox(height: 20.h),
        TextApp(
          text: context.translate(LangKeys.featuredTeachers),
          theme: context.textStyle.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        TextApp(
          text: context.translate(LangKeys.topRatedTutorsThisWeek),
          theme: context.textStyle.copyWith(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeightHelper.regular,
          ),
        ),
        SizedBox(height: 16.h),
        const TeachersList(),
        SizedBox(height: 24.h),
        const StudentTestimonials(),
      ],
    );
  }
}
