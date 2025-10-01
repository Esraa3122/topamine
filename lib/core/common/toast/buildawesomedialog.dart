import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

void buildAwesomeDialogError(String title, String desc, BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    title: title,
    desc: desc,
    btnOkText: 'OK',
    btnOkColor: Colors.red,
    btnOkOnPress: () {},
  ).show();
}

void buildAwesomeDialogSucces(
  String title,
  String desc,
  String btnOkText,
  BuildContext context,
  void Function()? btnOkOnPress,
) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    title: title,
    desc: desc,
    dialogBackgroundColor: context.color.mainColor,
      titleTextStyle: context.textStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeightHelper.bold,
        fontFamily: FontFamilyHelper.cairoArabic,
        letterSpacing: 0.5
      ),
    descTextStyle: context.textStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeightHelper.medium,
      fontFamily: FontFamilyHelper.cairoArabic,
      letterSpacing: 0.5
    ),
    btnOkText: btnOkText,
    btnOkColor: Colors.green,
    btnOkOnPress: btnOkOnPress,
  ).show();
}

void buildAwesomeDialogWarning(
  String title,
  String desc,
  BuildContext context,
) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    title: title,
    dialogBackgroundColor: context.color.mainColor,
      titleTextStyle: context.textStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeightHelper.bold,
        fontFamily: FontFamilyHelper.cairoArabic,
        letterSpacing: 0.5
      ),
    descTextStyle: context.textStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeightHelper.medium,
      fontFamily: FontFamilyHelper.cairoArabic,
      letterSpacing: 0.5
    ),
    desc: desc,
    btnOkText: 'OK',
    btnOkColor: Colors.amber,
    btnOkOnPress: () {},
  ).show();
}

void buildAwesomeDialogWarning2(
  String title,
  String desc,
  BuildContext context,
  VoidCallback onConfirm,
) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    title: title,
    dialogBackgroundColor: context.color.mainColor,
      titleTextStyle: context.textStyle.copyWith(
        fontSize: 22,
        fontWeight: FontWeightHelper.bold,
        fontFamily: FontFamilyHelper.cairoArabic,
        letterSpacing: 0.5
      ),
    descTextStyle: context.textStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeightHelper.medium,
      fontFamily: FontFamilyHelper.cairoArabic,
      letterSpacing: 0.5
    ),
    desc: desc,
    btnOkText: 'OK',
    btnCancelText: 'Cancel',
    btnOkColor: Colors.red,
    btnOkOnPress: onConfirm, 
    btnCancelOnPress: () {}, 
    btnCancelColor: Colors.amberAccent,
  ).show();
}
