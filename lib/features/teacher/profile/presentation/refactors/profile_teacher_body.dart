import 'package:flutter/material.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/auth/data/repos/auth_repo.dart';
import 'package:test/features/teacher/profile/presentation/widgets/settings_list_teacher.dart';
import 'package:test/features/teacher/profile/presentation/widgets/teacher_header.dart';
import 'package:test/features/teacher/profile/presentation/widgets/user_profile_shimmer.dart';

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
    return authRepo.getUserData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: _getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: UserProfileShimmer());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user data found.'));
        }
        final userModel = snapshot.data!;
        return Column(
          children: [
            TeacherHeader(userModel: userModel),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SettingsListTeacher(
                      userModel: userModel,
                      onUserUpdated: () {
                        setState(() {});
                      },
                    ),
                    // const LogoutButton(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
