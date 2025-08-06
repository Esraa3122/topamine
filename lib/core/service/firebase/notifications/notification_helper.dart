import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('رسالة في الخلفية: ${message.messageId}');
  handleNotificationNavigation(message);
}

Future<void> setupFlutterNotifications() async {
  var messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'إشعارات مهمة',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  const initializationSettingsAndroid = AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null && response.payload!.isNotEmpty) {
        await navigateToCourseDetails(response.payload!);
      }
    },
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    var notification = message.notification;
    var android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
          ),
        ),
        payload: message.data['courseId']?.toString() ?? '',
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    handleNotificationNavigation(message);
  });

  await FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      handleNotificationNavigation(message);
    }
  });
}

Future<void> subscribeToCourseTopicIfStudent() async {
  final prefs = SharedPref().getPreferenceInstance();
  final role = prefs.getString('role');

  if (role == 'student') {
    await FirebaseMessaging.instance.subscribeToTopic('students');
    debugPrint(' تم الاشتراك في توبك students بنجاح');
  }
}

void handleNotificationNavigation(RemoteMessage message) {
  final courseId = message.data['courseId'];
  if (courseId != null && courseId.toString().isNotEmpty) {
    navigateToCourseDetails(courseId.toString());
  }
}

Future<void> navigateToCourseDetails(String courseId) async {
  try {
    final doc = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .get();

    if (doc.exists) {
      final courseData = CoursesModel.fromJson(doc.data()!);
      await sl<GlobalKey<NavigatorState>>().currentState?.pushNamed(
        AppRoutes.courseDetails,
        arguments: courseData,
      );
    }
  } catch (e) {
    debugPrint('خطأ أثناء فتح صفحة الكورس: $e');
  }
}
