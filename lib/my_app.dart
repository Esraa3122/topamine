import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/app/app_cubit/app_cubit.dart';
import 'package:test/core/app/connectivity_controller.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/language/app_localizations_setup.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/shared_pref/pref_keys.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';
import 'package:test/core/style/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectivityController.instance.isConnected,
      builder: (_, value, _) {
        return BlocProvider(
          create: (context) => sl<AppCubit>()
            ..changeAppThemeMode(
              sharedMode: SharedPref().getBoolean(PrefKeys.themeMode),
            )
            ..getSavedLanguage(),
          child: ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            child: BlocBuilder<AppCubit, AppState>(
              buildWhen: (previos, current) {
                return previos != current;
              },
              builder: (context, state) {
                final cubit = context.read<AppCubit>();

                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Topamin',
                  theme: cubit.isDark ? themeLight() : themeDark(),
                  locale: Locale(cubit.currentLangCode),
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegate,
                  localeResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,
                  builder: (context, widget) {
                    return GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: Scaffold(
                        body: Builder(
                          builder: (context) {
                            ConnectivityController.instance.init();
                            return widget!;
                          },
                        ),
                      ),
                    );
                  },
                  navigatorKey: sl<GlobalKey<NavigatorState>>(),
                  onGenerateRoute: AppRoutes.onGenerateRoute,
                  
                  initialRoute: AppRoutes.splash
                );
              },
            ),
          ),
        );
      },
    );
  }
}
