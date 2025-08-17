import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/navigation/cubit/student_navigation_cubit.dart';

class CustomBottomNavBarStudent extends StatelessWidget {
  const CustomBottomNavBarStudent({super.key});

  int _navEnumToIndex(NavBarEnum navEnum) {
    switch (navEnum) {
      case NavBarEnum.home:
        return 0;
      case NavBarEnum.search:
        return 1;
      case NavBarEnum.booking:
        return 2;
      case NavBarEnum.profile:
        return 3;
    }
  }

  NavBarEnum _indexToNavEnum(int index) {
    switch (index) {
      case 0:
        return NavBarEnum.home;
      case 1:
        return NavBarEnum.search;
      case 2:
        return NavBarEnum.booking;
      case 3:
        return NavBarEnum.profile;
      default:
        return NavBarEnum.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomFadeInUp(
      duration: 88,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 70.h,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: context.color.navBarbg,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: BlocBuilder<StudentNavigationCubit, StudentNavigationState>(
            builder: (context, state) {
              final cubit = context.read<StudentNavigationCubit>();

              return BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: _navEnumToIndex(cubit.navBarEnum),
                selectedItemColor: Colors.blue.shade700,
                unselectedItemColor: Colors.grey.shade400,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                onTap: (index) {
                  final selectedEnum = _indexToNavEnum(index);
                  cubit.selectedNavBarIcons(selectedEnum);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: '',
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
