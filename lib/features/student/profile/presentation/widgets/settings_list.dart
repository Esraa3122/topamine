import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/profile/presentation/widgets/settings_card.dart';
import 'package:test/features/teacher/profile/presentation/widgets/about_us.dart';
import 'package:test/features/teacher/profile/presentation/widgets/contact_us.dart';
import 'package:test/features/teacher/profile/presentation/widgets/dark_mode_change.dart';
import 'package:test/features/teacher/profile/presentation/widgets/edit_profile_teacher.dart';
import 'package:test/features/teacher/profile/presentation/widgets/language_change.dart';
import 'package:test/features/teacher/profile/presentation/widgets/logout_widget.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({
    required this.userModel,
    required this.onUserUpdated,
    super.key,
  });
  final UserModel userModel;
  final VoidCallback onUserUpdated;

  @override
  Widget build(BuildContext context) {
    final currentUserId = userModel.userId;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        int notificationCount = snapshot.hasData
            ? snapshot.data!.docs.length
            : 0;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            children: [
              SettingsCard(
                iconColor: Colors.purple[300]!,
                icon: const Icon(Icons.notifications, color: Colors.white),
                title: context.translate(LangKeys.notifications),
                subtitle: context
                    .translate(LangKeys.newNotifications)
                    .replaceAll('$count', notificationCount.toString()),
                onTap: () async {
                  final notificationsRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUserId)
                      .collection('notifications');
                  final unreadDocs = await notificationsRef
                      .where('read', isEqualTo: false)
                      .get();
                  for (var doc in unreadDocs.docs) {
                    await doc.reference.update({'read': true});
                  }

                  await context.pushNamed(AppRoutes.notifications);
                },
                badgeCount: notificationCount,
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                iconColor: Colors.deepOrange[300]!,
                icon: SvgPicture.asset(
                  AppImages.language,
                  color: Colors.white,
                  height: 24.h,
                ),
                titleWidget: const LanguageChange(),
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                iconColor: Colors.green,
                icon: SvgPicture.asset(
                  AppImages.darkMode,
                  color: Colors.white,
                  height: 24.h,
                ),
                titleWidget: const DarkModeChange(),
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                iconColor: Colors.amber[300]!,
                icon: const Icon(Icons.edit, color: Colors.white),
                titleWidget: EditProfileTeacher(
                  onTap: () async {
                    final updatedUser = await context.pushNamed(
                      AppRoutes.editProfileStudentScreen,
                      arguments: userModel,
                    );
                    if (updatedUser != null) {
                      onUserUpdated();
                    }
                  },
                ),
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                iconColor: Colors.blueGrey[300]!,
                icon: const Icon(Icons.phone, color: Colors.white),
                titleWidget: const ContactUs(),
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                iconColor: Colors.blue[300]!,
                icon: const Icon(Icons.info, color: Colors.white),
                titleWidget: const AboutUs(),
              ),
              SizedBox(height: 12.h),
              SettingsCard(
                iconColor: Colors.red,
                icon: SvgPicture.asset(
                  AppImages.logout,
                  color: Colors.white,
                ),
                titleWidget: const LogOutWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
