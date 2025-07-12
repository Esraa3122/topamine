import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:test/core/app/app_cubit/app_cubit.dart';
import 'package:test/core/service/shared_pref/shared_pref_helper.dart';
import 'package:test/features/auth/data/datasources/auth_data_source.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';
import 'package:test/features/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:test/features/student/navigation/cubit/student_navigation_cubit.dart';
import 'package:test/features/teacher/navigation/cubit/teacher_navigation_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> setupInjector() async {
  await _initCore();
  await _initAuth();
  await _initMain();
}

Future<void> _initCore() async {
  // final dio = DioFactory.getDio();
  final navigatorKey = GlobalKey<NavigatorState>();
  sl
  ..registerFactory(AppCubit.new)
  // ..registerLazySingleton<ApiService>(() => ApiService(dio))
  ..registerSingleton<GlobalKey<NavigatorState>>(navigatorKey);
  // ..registerFactory(() => UploadImageCubit(sl()))
  // // ..registerFactory(ShareCubit.new)
  // ..registerLazySingleton(() => UploadImageRepo(sl()))
  // ..registerLazySingleton(() => UploadImageDataSource(sl()));
}

Future<void> _initAuth() async {
 sl
  ..registerFactory(() => AuthCubit(sl()))
    ..registerLazySingleton(() => AuthRepos(sl(), sl()))
    ..registerLazySingleton(AuthDataSource.new)
    ..registerLazySingleton(SharedPrefHelper.new);
  // sl.registerLazySingleton(() => SharedPref());
  // await sl<SharedPref>().init();
  // ..registerFactory(() => AppCubit(sl()))
  // ..registerLazySingleton(() => AuthRepos(sl()))
  // ..registerLazySingleton(() => AuthDataSource(sl()));
}

Future<void> _initMain() async {
  sl
  ..registerFactory(StudentNavigationCubit.new)
  ..registerFactory(TeacherNavigationCubit.new);
}
