import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return BlocBuilder<StudentNavigationCubit, StudentNavigationState>(
      builder: (context, state) {
        final cubit = context.read<StudentNavigationCubit>();
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
            items: List.generate(4, (index) {
              final navEnum = _indexToNavEnum(index);
              final isSelected = currentIndex == index;

              IconData icon;
              switch (navEnum) {
                case NavBarEnum.home:
                  icon = Icons.home;
                  break;
                case NavBarEnum.search:
                  icon = Icons.search;
                  break;
                case NavBarEnum.booking:
                  icon = Icons.calendar_month;
                  break;
                case NavBarEnum.profile:
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
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:test/core/common/animations/animate_do.dart';
// import 'package:test/core/enums/nav_bar_enum.dart';
// import 'package:test/core/extensions/context_extension.dart';
// import 'package:test/features/student/navigation/cubit/student_navigation_cubit.dart';

// class CustomBottomNavBarStudent extends StatelessWidget {
//   const CustomBottomNavBarStudent({super.key});

//   int _navEnumToIndex(NavBarEnum navEnum) {
//     switch (navEnum) {
//       case NavBarEnum.home:
//         return 0;
//       case NavBarEnum.search:
//         return 1;
//       case NavBarEnum.booking:
//         return 2;
//       case NavBarEnum.profile:
//         return 3;
//     }
//   }

//   NavBarEnum _indexToNavEnum(int index) {
//     switch (index) {
//       case 0:
//         return NavBarEnum.home;
//       case 1:
//         return NavBarEnum.search;
//       case 2:
//         return NavBarEnum.booking;
//       case 3:
//         return NavBarEnum.profile;
//       default:
//         return NavBarEnum.home;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomFadeInUp(
//       duration: 88,
//       child: Align(
//         alignment: Alignment.bottomCenter,
//         child: Container(
//           height: 70.h,
//           margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//           padding: EdgeInsets.symmetric(horizontal: 20.w),
//           decoration: BoxDecoration(
//             color: context.color.navBarbg,
//             borderRadius: BorderRadius.circular(25),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 15,
//                 offset: Offset(0, 5),
//               ),
//             ],
//           ),
//           child: BlocBuilder<StudentNavigationCubit, StudentNavigationState>(
//             builder: (context, state) {
//               final cubit = context.read<StudentNavigationCubit>();
//               final currentIndex = _navEnumToIndex(cubit.navBarEnum);

//               return Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(4, (index) {
//                   final isSelected = index == currentIndex;
//                   final navEnum = _indexToNavEnum(index);

//                   IconData icon;
//                   switch (navEnum) {
//                     case NavBarEnum.home:
//                       icon = Icons.home;
//                       break;
//                     case NavBarEnum.search:
//                       icon = Icons.search;
//                       break;
//                     case NavBarEnum.booking:
//                       icon = Icons.calendar_month;
//                       break;
//                     case NavBarEnum.profile:
//                       icon = Icons.person;
//                       break;
//                   }

//                   return GestureDetector(
//                     onTap: () {
//                       cubit.selectedNavBarIcons(navEnum);
//                     },
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       padding: EdgeInsets.all(isSelected ? 10.w : 5.w),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: isSelected
//                             ? LinearGradient(
//                                 colors: [
//                                   context.color.bluePinkLight!,
//                                   context.color.bluePinkDark!,
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               )
//                             : null,
//                       ),
//                       child: Icon(
//                         icon,
//                         size: isSelected ? 28.sp : 24.sp,
//                         color: isSelected
//                             ? Colors.white
//                             : Colors.grey.shade400,
//                       ),
//                     ),
//                   );
//                 }),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
