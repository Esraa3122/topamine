import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/teacher/navigation/cubit/teacher_navigation_cubit.dart';

class NavigationTeacherAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NavigationTeacherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    Stream<int> unreadMessagesStream() async* {
      await for (final chatsSnap
          in FirebaseFirestore.instance.collection('chats')
          .where('participants', arrayContains: currentUserId)
          .snapshots()) {
        var total = 0;
        for (final chatDoc in chatsSnap.docs) {
          final messagesSnap = await chatDoc.reference
              .collection('messages')
              .get();
          for (final msgDoc in messagesSnap.docs) {
            final data = msgDoc.data();
            if (data['createdBy'] != currentUserId && data['isRead'] == false) {
              total += 1;
            }
          }
        }
        yield total;
      }
    }

    final cubit = context.read<TeacherNavigationCubit>();
    return SizedBox(
      height: 100.h,
      child: AppBar(
        toolbarHeight: 100.h,
        automaticallyImplyLeading: false,
        backgroundColor: context.color.mainColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            if (cubit.navBarEnum == NavBarEnum2.home) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUserId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!.data()! as Map<String, dynamic>;
                  final teacherName = data['name'] ?? 'Teacher';
                  final teacherPhoto = data['avatar'] as String?;
                  final subject = data['subject'] as String?;

                  return Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        radius: 22.r,
                        backgroundImage:
                            teacherPhoto != null && teacherPhoto.isNotEmpty
                            ? NetworkImage(teacherPhoto)
                            : null,
                        backgroundColor: Colors.grey,
                        child: teacherPhoto == null || teacherPhoto.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),
                      title: TextApp(
                        text: teacherName.toString(),
                        theme: context.textStyle.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeightHelper.bold,
                          fontFamily: FontFamilyHelper.cairoArabic,
                          letterSpacing: 0.5,
                        ),
                      ),
                      subtitle: TextApp(
                        text: subject != null && subject.isNotEmpty
                            ? '${context.translate(LangKeys.iAmATeacher)} $subject'
                            : 'اختصاصك',
                        theme: context.textStyle.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeightHelper.regular,
                          fontFamily: FontFamilyHelper.cairoArabic,
                          letterSpacing: 0.5,
                        ),
                      ),
                      trailing: StreamBuilder<int>(
                        stream:
                            unreadMessagesStream(), // نفس الفنكشن اللى عندك فوق
                        builder: (context, snapshot) {
                          final unreadCount = snapshot.data ?? 0;

                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                onPressed: () => context.pushNamed(
                                  AppRoutes.studentListScreen,
                                ),
                                icon: Icon(
                                  Icons.message,
                                  color: Colors.blue.shade600,
                                  size: 28.sp,
                                ),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 0,
                                  top: -2,
                                  child: Container(
                                    padding: EdgeInsets.all(4.r),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 18.w,
                                      minHeight: 18.h,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$unreadCount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (cubit.navBarEnum == NavBarEnum2.booking) {
              return CustomFadeInRight(
                duration: 800,
                child: Center(
                  child: TextApp(
                    text: context.translate(LangKeys.myCourses),
                    theme: context.textStyle.copyWith(
                      fontSize: 23.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor,
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            } else if (cubit.navBarEnum == NavBarEnum2.profile) {
              return CustomFadeInRight(
                duration: 800,
                child: Center(
                  child: TextApp(
                    text: context.translate(LangKeys.profileAccount),
                    theme: context.textStyle.copyWith(
                      fontSize: 23.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor,
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 70.h);
}
