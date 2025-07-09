import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';
import 'package:test/features/teacher/profile/presentation/widgets/dark_mode_change.dart';
import 'package:test/features/teacher/profile/presentation/widgets/language_change.dart';
import 'package:test/features/teacher/profile/presentation/widgets/logout_widget.dart';
import 'package:test/features/teacher/profile/presentation/widgets/teacher_profile_info.dart';

class ProfileTeacherBody extends StatefulWidget {
  const ProfileTeacherBody({super.key});

  @override
  State<ProfileTeacherBody> createState() => _ProfileTeacherBodyState();
}

class _ProfileTeacherBodyState extends State<ProfileTeacherBody> {
  final AuthRepos authRepo = sl<AuthRepos>();

  Future<UserModel?> _getUser() async {
    final uid = await authRepo.sharedPref.getUserId();
    if (uid == null) return null;

    final data = await authRepo.getUserData(uid);
    if (data == null) return null;

    return UserModel.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //User Profile Info
            Center(
              child: FutureBuilder<UserModel?>(
                future: _getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No user data found.'));
                  }

                  return TeacherProfileInfo(user: snapshot.data!);
                },
              ),
            ),
            //title
            SizedBox(
              height: 20.h,
            ),
            CustomFadeInRight(
              duration: 400,
              child: TextApp(
                text: 'ميزات التطبيق',
                theme: context.textStyle.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeightHelper.bold,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            // language
            const CustomFadeInRight(duration: 400, child: LanguageChange()),
            SizedBox(height: 20.h),
            // dark mode
            const CustomFadeInRight(
              duration: 400,
              child: DarkModeChange(),
            ),
            SizedBox(height: 20.h),
            // Build Developer
            // const CustomFadeInRight(
            //   duration: 400,
            //   child: BuildDeveloper(),
            // ),
            // SizedBox(height: 20.h),
            // Notifications change
            // const CustomFadeInRight(
            //   duration: 400,
            //   child: NotificationsChange(),
            // ),
            // SizedBox(height: 20.h),
            // Build Version
            // const CustomFadeInRight(
            //   duration: 400,
            //   child: BuildVersion(),
            // ),
            // SizedBox(height: 20.h),
            // Logout
            const CustomFadeInRight(
              duration: 400,
              child: LogOutWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
