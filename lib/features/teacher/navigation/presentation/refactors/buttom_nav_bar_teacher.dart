import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
          child: BlocBuilder<TeacherNavigationCubit, TeacherNavigationState>(
      builder: (context, state) {
        final cubit = context.read<TeacherNavigationCubit>();
        final currentIndex = _navEnumToIndex(cubit.navBarEnum);

        return Container(
          decoration: BoxDecoration(
            // gradient: const LinearGradient(
            //   colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: CurvedNavigationBar(
            index: currentIndex,
            height: 60.h,
            backgroundColor: Colors.transparent,
            color: context.color.mainColor!,
            buttonBackgroundColor: Colors.transparent,
            animationCurve: Curves.easeInOutCubic,
            animationDuration: const Duration(milliseconds: 500),
            items: List.generate(3, (index) {
              final navEnum = _indexToNavEnum(index);
              final isSelected = currentIndex == index;

              IconData icon;
              switch (navEnum) {
                case NavBarEnum2.home:
                  icon = Icons.home;
                  break;
                case NavBarEnum2.booking:
                  icon = Icons.video_collection_sharp;
                  break;
                case NavBarEnum2.profile:
                  icon = Icons.person;
                  break;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(isSelected ? 10.w : 6.w),
                decoration: isSelected
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            context.color.bluePinkLight!,
                            context.color.bluePinkDark!,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      )
                    : const BoxDecoration(shape: BoxShape.circle),
                child: Icon(
                  icon,
                  size: 28,
                  color: isSelected ? Colors.white : context.color.navBarSelectedTab,
                ),
              );
            }),
            onTap: (index) {
              cubit.selectedNavBarIcons(_indexToNavEnum(index));
            },
          ),
        );
      },
    )

    );
  }
}