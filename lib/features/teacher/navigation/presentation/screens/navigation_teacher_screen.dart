import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/features/student/home/presentation/screens/home_student_screen.dart';
import 'package:test/features/student/search/presentation/screen/search_page.dart';
import 'package:test/features/teacher/booking/presentation/screen/booking_teacher_screen.dart';
import 'package:test/features/teacher/navigation/cubit/teacher_navigation_cubit.dart';
import 'package:test/features/teacher/navigation/presentation/refactors/buttom_nav_bar_teacher.dart';
import 'package:test/features/teacher/navigation/presentation/refactors/navigation_teacher_app_bar.dart';
import 'package:test/features/teacher/profile/presentation/screens/profile_teacher_screen.dart';

class NavigationTeacherScreen extends StatelessWidget {
  const NavigationTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<TeacherNavigationCubit>(),
      child: Scaffold(
        appBar: const NavigationTeacherAppBar(),
        body: Container(
          constraints: const BoxConstraints.expand(),
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(context.images.mainLight!),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          child: Column(
            children: [
              Expanded(
                child:
                    BlocBuilder<TeacherNavigationCubit, TeacherNavigationState>(
                      builder: (context, state) {
                        final cubit = context.read<TeacherNavigationCubit>();
                        if (cubit.navBarEnum == NavBarEnum.booking) {
                          return const BookingTeacherScreen();
                        } else if (cubit.navBarEnum == NavBarEnum.profile) {
                          return const ProfileTeacherScreen();
                        } else if (cubit.navBarEnum == NavBarEnum.search) {
                          return const SearchPage();
                        }
                        return const HomePage();
                      },
                    ),
              ),
              const ButtomNavBarTeacher(),
            ],
          ),
        ),
      ),
    );
  }
}
