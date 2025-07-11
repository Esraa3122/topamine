import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/app/app_cubit/app_cubit.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/app_localizations.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class DarkAndLangButtons extends StatelessWidget {
  const DarkAndLangButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dark Mode Button
        BlocBuilder(
          bloc: cubit,
          builder: (context, state) {
            return CustomFadeInRight(
              duration: 400,
              child: CustomLinearButton(
                  onPressed: cubit.changeAppThemeMode,
                  height: 44.h,
                  width: 50.h,
                  child: Icon(
                    cubit.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: Colors.white,
                  )),
            );
          },
        ),
        // Languages Button
        CustomFadeInLeft(
          duration: 400,
          child: CustomLinearButton(
            onPressed: () {
              if (AppLocalizations.of(context)!.isEnLocal) {
                cubit.toArabic();
              } else {
                cubit.toEnglish();
              }
            },
            height: 44.h,
            width: 100.w,
            child: TextApp(
                text: context.translate(LangKeys.language),
                theme: context.textStyle.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: Colors.white)),
          ),
        )
      ],
    );
  }
}
