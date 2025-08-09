import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/dialogs/donor_dialogs.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/service/shared_pref/shared_pref.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/presentation/screen/login_screen.dart';
import 'package:test/features/teacher/profile/presentation/refactors/list_chat.dart';

List<DrawerItemModel> profileDrawerList(BuildContext context) {
  return <DrawerItemModel>[
    //DashBoard
    DrawerItemModel(
      icon: const Icon(
        Icons.dashboard,
        color: Colors.white,
      ),
      title: TextApp(
        text: 'DashBoard',
        theme: context.textStyle.copyWith(
          color: Colors.white,
          fontSize: 17.sp,
          fontFamily: FontFamilyHelper.poppinsEnglish,
          fontWeight: FontWeight.bold,
        ),
      ),
      page: const StudentsListScreen(),
    ),
    // //Categories
    // DrawerItemModel(
    //   icon: const Icon(
    //     Icons.bloodtype_rounded,
    //     color: Colors.white,
    //   ),
    //   title: TextApp(
    //     text: 'Donors',
    //     theme: context.textStyle.copyWith(
    //       color: Colors.white,
    //       fontSize: 17.sp,
    //       fontFamily: FontFamilyHelper.poppinsEnglish,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   page: const EditProfileTeacherScreen(user: ,),
    // ),
    // //Users
    // DrawerItemModel(
    //   icon: const Icon(
    //     Icons.people_alt_outlined,
    //     color: Colors.white,
    //   ),
    //   title: TextApp(
    //     text: 'Users',
    //     theme: context.textStyle.copyWith(
    //       color: Colors.white,
    //       fontSize: 17.sp,
    //       fontFamily: FontFamilyHelper.poppinsEnglish,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   page: const UsersScreen(),
    // ),
    // //Notifications
    // DrawerItemModel(
    //   icon: const Icon(
    //     Icons.notifications_active_rounded,
    //     color: Colors.white,
    //   ),
    //   title: TextApp(
    //     text: 'Notifications',
    //     theme: context.textStyle.copyWith(
    //       color: Colors.white,
    //       fontSize: 17.sp,
    //       fontFamily: FontFamilyHelper.poppinsEnglish,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    //   page: const AddNotificationScreen(),
    // ),
    //LogOut
    DrawerItemModel(
      icon: const Icon(
        Icons.exit_to_app,
        color: Colors.white,
      ),
      title: GestureDetector(
        onTap: () {
          CustomDialog.twoButtonDialog(
            context: context,
            textBody: 'Do you want log out?',
            textButton1: 'Yes',
            textButton2: 'No',
            isLoading: false,
            onPressed: () async {
             CustomDialog.twoButtonDialog(
              context: context,
              textBody: context.translate(LangKeys.logOutFromApp),
              textButton1: context.translate(LangKeys.yes),
              textButton2: context.translate(LangKeys.no),
              isLoading: false,
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await SharedPref.preferences.clearPreferences();
                // await context.pushNamedAndRemoveUntil(AppRoutes.login);
              },
            );
            },
          );
        },
        child: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeightHelper.bold,
            fontSize: 17,
          ),
        ),
      ),
      page: const LoginScreen(),
    ),
  ];
}

class DrawerItemModel {
  DrawerItemModel({
    required this.icon,
    required this.title,
    required this.page,
  });

  final Icon icon;
  final Widget title;
  final Widget page;
}
