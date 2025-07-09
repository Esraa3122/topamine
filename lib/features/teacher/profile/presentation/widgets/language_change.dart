import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/core/app/app_cubit/app_cubit.dart';
import 'package:test/core/common/dialogs/donor_dialogs.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/app_localizations.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';


class LanguageChange extends StatelessWidget {
  const LanguageChange({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();
    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return Row(
          children: [
            SvgPicture.asset(
              AppImages.language,
              color: context.color.textColor,
            ),
            SizedBox(width: 10.w),
            TextApp(
              text: context.translate(LangKeys.languageTilte),
              theme: context.textStyle.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeightHelper.regular,
              ),
            ),
            const Spacer(),
            //language button
            InkWell(
              onTap: () {
                //dialog
                CustomDialog.twoButtonDialog(
                  context: context,
                  textBody: context.translate(LangKeys.changeToTheLanguage),
                  textButton1: context.translate(LangKeys.sure),
                  textButton2: context.translate(LangKeys.cancel),
                  isLoading: false,
                  onPressed: () {
                    selectLanguagesButton(
                      context: context,
                      cubit: cubit,
                    );
                  },
                );
              },
              child: Row(
                children: [
                  TextApp(
                    text: context.translate(LangKeys.langCode),
                    theme: context.textStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.regular,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: context.color.textColor,
                    size: 15,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void selectLanguagesButton({
    required BuildContext context,
    required AppCubit cubit,
  }) {
    if (AppLocalizations.of(context)!.isEnLocal) {
      cubit.toArabic();
    } else {
      cubit.toEnglish();
    }
    context.pop();
  }
}
