import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:test/core/service/shared_pref/pref_keys.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    const timeOut = Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut
        ..options.headers['Authorization'] =
            'Bearer  ${SharedPref().getString(PrefKeys.accessToken)}';

      debugPrint(
        "[USER Token] ====> ${SharedPref().getString(PrefKeys.accessToken) ?? 'NULL TOKEN'}",
      );

      addDioInterceptor();
      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        request: false,
        compact: false,
      ),
    );
    // dio?.interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest: (options, handler) {
    //       options.headers['Authorization'] =
    //           'Bearer ${SharedPref().getString(PrefKeys.accessToken)}';

    //       return handler.next(options);
    //     },
    //     onError: (error, handler) async {
    //       if (error.response?.statusCode == 400 ||
    //       error.response?.statusCode == 401) {
    //         await AppLogout().logout();
    //       }
    //     },
    //   ),
    // );
  }
}
