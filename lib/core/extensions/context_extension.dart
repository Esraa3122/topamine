import 'package:flutter/material.dart';
import 'package:test/core/language/app_localizations.dart';
import 'package:test/core/style/theme/assets_extension.dart';
import 'package:test/core/style/theme/color_extension.dart';

extension ContextExtension on BuildContext {
   // color
  MyColor get color => Theme.of(this).extension<MyColor>()!;

  // images
  MyAssets get images => Theme.of(this).extension<MyAssets>()!;

  // styles
  TextStyle get textStyle => Theme.of(this).textTheme.displaySmall!;

  // Language
  String translate(String langkey) {
    return AppLocalizations.of(this)!.translate(langkey).toString();
  }

  // Navigation
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(
      this,
    ).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      this,
    ).pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  void pop() => Navigator.of(this).pop();
}
