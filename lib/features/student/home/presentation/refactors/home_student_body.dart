import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/firebase/notifications/notification_helper.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/home/presentation/widgets/auto_slider.dart';
import 'package:test/features/student/home/presentation/widgets/course_for_you.dart';
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

  void listenForNewCourses() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final currentUserId = currentUser.uid;

    FirebaseFirestore.instance
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.docs.isEmpty) return;

          final courseDoc = snapshot.docs.first;
          final course = courseDoc.data();

          final courseId = courseDoc.id;
          final teacherId = course['teacherId'] ?? '';
          final courseTitle = course['title'] ?? 'كورس جديد';
          final message = 'تم إضافة الكورس "$courseTitle" للتو!';

          final followerDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(teacherId.toString())
              .collection('followers')
              .doc(currentUserId)
              .get();

          if (!followerDoc.exists) return;

          final notifiedDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('notifications')
              .doc(courseId)
              .get();

          if (notifiedDoc.exists) return;

          int notificationId = courseId.hashCode;

          await flutterLocalNotificationsPlugin.show(
            notificationId,
            'كورس جديد',
            message,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'إشعارات مهمة',
                importance: Importance.high,
              ),
            ),
            payload: courseId,
          );

          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .collection('notifications')
              .doc(courseId)
              .set({
                'courseId': courseId,
                'title': courseTitle,
                'message': message,
                'read': false,
                'createdAt': FieldValue.serverTimestamp(),
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Center(child: Text("User not logged in"));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data();

            final currentUserName = data?['name'] ?? 'طالب';
            final currentUserPhoto = data?['avatar'] ?? '';
            return Row(
              children: [
                CircleAvatar(
                  backgroundColor: context.color.bluePinkLight,
                  backgroundImage: currentUserPhoto.toString().isNotEmpty
                      ? NetworkImage(currentUserPhoto.toString())
                      : const AssetImage(AppImages.home1) as ImageProvider,
                  radius: 24.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        text: '${context.translate(LangKeys.welcome)} , $currentUserName',
                        theme: context.textStyle.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeightHelper.bold,
                          letterSpacing: 0.5,
                          fontFamily: FontFamilyHelper.cairoArabic,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextApp(
                        text: context.translate(LangKeys.weWishYouToHaveAGreatTimeInTopamin),
                        theme: context.textStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeightHelper.regular,
                          letterSpacing: 0.5,
                          fontFamily: FontFamilyHelper.cairoArabic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 20.h),
        const BannerSliders(),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextApp(
              text: context.translate(LangKeys.coursesForYou),
              theme: context.textStyle.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeightHelper.bold,
                letterSpacing: 0.5,
                fontFamily: FontFamilyHelper.cairoArabic,
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
                  letterSpacing: 0.5,
                  fontFamily: FontFamilyHelper.cairoArabic,
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
            fontSize: 17.sp,
            fontWeight: FontWeightHelper.bold,
            letterSpacing: 0.5,
            fontFamily: FontFamilyHelper.cairoArabic,
          ),
        ),
        SizedBox(height: 5.h),
        TextApp(
          text: context.translate(LangKeys.topRatedTutorsThisWeek),
          theme: context.textStyle.copyWith(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeightHelper.regular,
            letterSpacing: 0.5,
            fontFamily: FontFamilyHelper.cairoArabic,
          ),
        ),
        SizedBox(height: 16.h),
        const TeachersList(),
        SizedBox(height: 20.h),
      ],
    );
  }
}
