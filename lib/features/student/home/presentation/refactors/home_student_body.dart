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
import 'package:test/core/style/fonts/font_weight_helper.dart';
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
  // String searchQuery = '';
  @override
  void initState() {
    super.initState();
    listenForNewCourses();
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


  // void listenForNewCourses() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;

  //   final currentUserId = currentUser.uid;

  //   FirebaseFirestore.instance
  //       .collection('courses')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .listen((snapshot) async {
  //     if (snapshot.docs.isEmpty) return;

  //     final courseDoc = snapshot.docs.first;
  //     final course = courseDoc.data();

  //     final courseId = courseDoc.id;
  //     final teacherId = course['teacherId'] ?? '';
  //     final courseTitle = course['title'] ?? 'كورس جديد';
  //     final message = 'تم إضافة الكورس "$courseTitle" للتو!';

  //     final followerDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(teacherId.toString())
  //         .collection('followers')
  //         .doc(currentUserId)
  //         .get();

  //     if (!followerDoc.exists) return;

  //     final notifiedDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('notifications')
  //         .doc(courseId)
  //         .get();

  //     if (notifiedDoc.exists) return;

  //     int notificationId = courseId.hashCode;

  //     await flutterLocalNotificationsPlugin.show(
  //       notificationId,
  //       '📚 كورس جديد',
  //       message,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'إشعارات مهمة',
  //           importance: Importance.high,
  //         ),
  //       ),
  //       payload: courseId,
  //     );

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .collection('notifications')
  //         .doc(courseId)
  //         .set({
  //       'courseId': courseId,
  //       'title': courseTitle,
  //       'message': message,
  //       'read': false,
  //       'createdAt': FieldValue.serverTimestamp(),
  //     });
  //   });
  // }

  // void listenForNewCourses() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) return;

  //   final currentUserId = currentUser.uid;

  //   final DateTime screenOpenedAt = DateTime.now();

  //   FirebaseFirestore.instance.collection('courses').snapshots().listen(
  //     (snapshot) async {
  //       List<Future> futures = [];

  //       for (final change in snapshot.docChanges) {
  //         if (change.type == DocumentChangeType.added) {
  //           futures.add(() async {
  //             final course = change.doc.data();
  //             if (course == null) return;

  //             final Timestamp? createdAtTimestamp =
  //                 course['createdAt'] is Timestamp
  //                 ? course['createdAt'] as Timestamp
  //                 : null;
  //             if (createdAtTimestamp == null) {
  //               return;
  //             }

  //             final DateTime createdAt = createdAtTimestamp.toDate();

  //             if (createdAt.isBefore(screenOpenedAt)) {
  //               return;
  //             }

  //             final courseId = change.doc.id;
  //             final teacherId = course['teacherId'] ?? '';
  //             final courseTitle = course['title'] ?? 'كورس جديد';
  //             final message = 'تم إضافة الكورس "$courseTitle" للتو!';

  //             final followerDoc = await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(teacherId.toString())
  //                 .collection('followers')
  //                 .doc(currentUserId)
  //                 .get();

  //             if (!followerDoc.exists) {
  //               return;
  //             }

  //             final notifiedDoc = await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(currentUserId)
  //                 .collection('notifications')
  //                 .doc(courseId)
  //                 .get();

  //             if (notifiedDoc.exists) {
  //               return;
  //             }

  //             int notificationId = courseId.hashCode;

  //             await flutterLocalNotificationsPlugin.show(
  //               notificationId,
  //               '📚 كورس جديد',
  //               message,
  //               const NotificationDetails(
  //                 android: AndroidNotificationDetails(
  //                   'high_importance_channel',
  //                   'إشعارات مهمة',
  //                   importance: Importance.high,
  //                 ),
  //               ),
  //               payload: courseId,
  //             );

  //             await FirebaseFirestore.instance
  //                 .collection('users')
  //                 .doc(currentUserId)
  //                 .collection('notifications')
  //                 .doc(courseId)
  //                 .set({
  //                   'courseId': courseId,
  //                   'title': courseTitle,
  //                   'message': message,
  //                   'read': false,
  //                   'createdAt': FieldValue.serverTimestamp(),
  //                 });
  //           }());
  //         }
  //       }

  //       await Future.wait(futures);
  //     },
  //   );
  // }

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
      ],
    );
  }
}
