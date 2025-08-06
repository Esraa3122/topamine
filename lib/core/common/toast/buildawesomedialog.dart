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

void buildAwesomeDialogSucces(String title, String desc, BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    title: title,
    desc: desc,
    btnOkText: 'OK',
    btnOkColor: Colors.lightBlue,
    btnOkOnPress: () {},
  ).show();
}
