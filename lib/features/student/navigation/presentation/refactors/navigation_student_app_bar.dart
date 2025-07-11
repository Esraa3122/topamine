import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/enums/nav_bar_enum.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/navigation/cubit/student_navigation_cubit.dart';

class NavigationStudentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const NavigationStudentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentNavigationCubit>();
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: context.color.mainColor,
      elevation: 0,
      title: BlocBuilder(
        bloc: cubit,
        builder: (context, state) {
          if (cubit.navBarEnum == NavBarEnum.home ||
              cubit.navBarEnum == NavBarEnum.search ||
              cubit.navBarEnum == NavBarEnum.booking) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomFadeInRight(
                  duration: 800,
                  child: TextApp(
                    text: context.translate(LangKeys.appName),
                    theme: context.textStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor,
                    ),
                  ),
                ),
                CustomFadeInLeft(
                  duration: 800,
                  child: Image.asset(
                    AppImages.logo,
                    width: 40.w,
                  ),
                ),
              ],
            );
          } else if (cubit.navBarEnum == NavBarEnum.profile) {
            return CustomFadeInRight(
              duration: 800,
              child: Center(
                child: TextApp(
                  text: context.translate(LangKeys.appName),
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 70.h);
}
