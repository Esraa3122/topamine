import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/app/bloc_observer.dart';
import 'package:test/core/app/env.variables.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/service/firebase/notifications/notification_helper.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';
import 'package:test/firebase_options.dart';
import 'package:test/my_app.dart';


void main() async {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(
    cloudName: 'duljb1fz3',
  );

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await EnvVariables.instance.init(envType: EnvTypeEnum.dev);
  await SharedPref().instantiatePreferences();
  await setupInjector();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await setupFlutterNotifications();
  await subscribeToCourseTopicIfStudent();

  await FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      handleNotificationNavigation(message);
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationNavigation);
  Bloc.observer = AppBlocObserver();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
  );

  runApp(const MyApp());
}
