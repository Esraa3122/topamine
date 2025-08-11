import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';
import 'package:test/features/student/edit_profile/presentation/screen/edit_profile_student_screen.dart';
import 'package:test/features/student/profile/presentation/widgets/profile_student_info.dart';
import 'package:test/features/teacher/profile/presentation/widgets/about_us.dart';
import 'package:test/features/teacher/profile/presentation/widgets/contact_us.dart';
import 'package:test/features/teacher/profile/presentation/widgets/dark_mode_change.dart';
import 'package:test/features/teacher/profile/presentation/widgets/edit_profile_teacher.dart';
import 'package:test/features/teacher/profile/presentation/widgets/language_change.dart';
import 'package:test/features/teacher/profile/presentation/widgets/logout_widget.dart';

class ProfileStudentBody extends StatefulWidget {
  const ProfileStudentBody({super.key});

  @override
  State<ProfileStudentBody> createState() => _ProfileStudentBodyState();
}

class _ProfileStudentBodyState extends State<ProfileStudentBody> {
  final AuthRepos authRepo = sl<AuthRepos>();

  Future<UserModel?> _getUser() async {
    final uid = await authRepo.sharedPref.getUserId();
    if (uid == null) return null;

    final data = await authRepo.getUserData(uid);
    if (data == null) return null;

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      child: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<UserModel?>(
            future: _getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No user data found.'));
              }

              final userModel = snapshot.data!;

              return Column(
                children: [
                  // معلومات البروفايل
                  ProfileStudentInfo(user: userModel),

                  const SizedBox(height: 20),

                  // عنوان الميزات
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

                  const SizedBox(height: 30),

                  // تغيير اللغة
                  const CustomFadeInRight(
                    duration: 400,
                    child: LanguageChange(),
                  ),
                  const SizedBox(height: 20),

                  // الوضع الليلي
                  const CustomFadeInRight(
                    duration: 400,
                    child: DarkModeChange(),
                  ),
                  const SizedBox(height: 20),

                  // تعديل البيانات
                  CustomFadeInRight(
                    duration: 400,
                    child: EditProfileTeacher(
                      onTap: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileStudentScreen(
                              user: userModel,
                            ),
                          ),
                        );
                        if (updatedUser != null) {
                          setState(() {});
                        }
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // اتصل بنا
                  const CustomFadeInRight(
                    duration: 400,
                    child: ContactUs(),
                  ),
                  const SizedBox(height: 20),

                  // من نحن
                 const CustomFadeInRight(
                    duration: 400,child: AboutUs()),
                  const SizedBox(height: 20),

                  // تسجيل الخروج
                  const CustomFadeInRight(
                    duration: 400,
                    child: LogOutWidget(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

