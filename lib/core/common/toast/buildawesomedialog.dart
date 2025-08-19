import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

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
    desc: desc,
    btnOkText: 'OK',
    btnOkColor: Colors.amber,
    btnOkOnPress: () {},
  ).show();
}
