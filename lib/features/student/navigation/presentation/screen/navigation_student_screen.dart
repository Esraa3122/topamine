import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/features/student/booking/presentation/screen/booking_student_screen.dart';
import 'package:test/features/student/home/presentation/screens/home_student_screen.dart';
import 'package:test/features/student/navigation/cubit/student_navigation_cubit.dart';
import 'package:test/features/student/navigation/presentation/refactors/bottom_nav_bar_student.dart';
import 'package:test/features/student/navigation/presentation/refactors/navigation_student_app_bar.dart';
import 'package:test/features/student/profile/presentation/screens/profile_student_screen.dart';
import 'package:test/features/student/search/presentation/screen/search_page.dart';

class NavigationStudentScreen extends StatelessWidget {
  const NavigationStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StudentNavigationCubit>(),
      child: Scaffold(
        appBar: const NavigationStudentAppBar(),
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
                    BlocBuilder<StudentNavigationCubit, StudentNavigationState>(
                      builder: (context, state) {
                        final cubit = context.read<StudentNavigationCubit>();
                        if (cubit.navBarEnum == NavBarEnum.booking) {
                          return const BookingStudentScreen();
                        } else if (cubit.navBarEnum == NavBarEnum.profile) {
                          return const ProfileStudentScreen();
                        } else if (cubit.navBarEnum == NavBarEnum.search) {
                          return const SearchPage();
                        }
                        return const HomePage();
                      },
                    ),
              ),
              const CustomBottomNavBarStudent(),
            ],
          ),
        ),
      ),
    );
  }
}
