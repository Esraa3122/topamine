import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/core/di/injection_container.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/features/booking/presentation/screen/booking_page.dart';
import 'package:test/features/home/presentation/screens/home_page.dart';
import 'package:test/features/navigation/cubit/main_cubit_cubit.dart';
import 'package:test/features/navigation/presentation/refactors/bottom_nav_bar.dart';
import 'package:test/features/navigation/presentation/refactors/navigation_teacher_app_bar.dart';
import 'package:test/features/search/presentation/screen/search_page.dart';
import 'package:test/features/student/profile/presentation/screens/profile_student_screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MainCubitCubit>(),
      child: Scaffold(
        appBar: const NavigationTeacherAppBar(),
        body: Container(
          constraints: const BoxConstraints.expand(),
          // decoration: const BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage(AppImages.mainPhoto),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<MainCubitCubit, MainCubitState>(
                      builder: (context, state) {
                    final cubit = context.read<MainCubitCubit>();
                    if (cubit.navBarEnum == NavBarEnum.booking) {
                      return const BookingPage();
                    } else if (cubit.navBarEnum == NavBarEnum.profile) {
                      return const ProfileStudentScreen();
                    } else if (cubit.navBarEnum == NavBarEnum.search) {
                      return const SearchPage();
                    }
                    return const HomePage();
                  }),
                ),
                const CustomBottomNavBar(),
              
            ],
          ),
        ),
      ),
    );
  }
}