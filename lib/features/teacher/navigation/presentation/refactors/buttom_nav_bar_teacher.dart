import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/teacher/navigation/cubit/teacher_navigation_cubit.dart';

class ButtomNavBarTeacher extends StatelessWidget {
  const ButtomNavBarTeacher({super.key});

  int _navEnumToIndex(NavBarEnum2 navEnum) {
    switch (navEnum) {
      case NavBarEnum2.home:
        return 0;
      // case NavBarEnum.search:
      //   return 1;
      case NavBarEnum2.booking:
        return 1;
      case NavBarEnum2.profile:
        return 2;
    }
  }

  NavBarEnum2 _indexToNavEnum(int index) {
    switch (index) {
      case 0:
        return NavBarEnum2.home;
      case 1:
        return NavBarEnum2.booking;
      case 2:
        return NavBarEnum2.profile;
      default:
        return NavBarEnum2.home;
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
          child: BlocBuilder<TeacherNavigationCubit, TeacherNavigationState>(
            builder: (context, state) {
              final cubit = context.read<TeacherNavigationCubit>();

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
                  // BottomNavigationBarItem(
                  //   icon: Icon(Icons.search),
                  //   label: '',
                  // ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.video_collection_outlined),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: ' ',
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