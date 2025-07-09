import 'package:flutter/material.dart';
import 'package:test/core/style/color/colors_light.dart';

class AppTextStyle {
  AppTextStyle._();

  static TextStyle mint26Color16Medium = const TextStyle(
    color: ColorsLight.mint26Color,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static TextStyle primaryColor16Medium = const TextStyle(
    color: ColorsLight.primaryColor,
    fontWeight: FontWeight.w500,
    fontSize: 16,
  );

  static TextStyle grey0BColor26Medium = const TextStyle(
    color: ColorsLight.grey0BColor,
    fontWeight: FontWeight.w500,
    fontSize: 30,
  );

  static TextStyle grey9FColor14Regular = const TextStyle(
    color: ColorsLight.grey9FColor,
    fontWeight: FontWeight.normal,
    fontSize: 17,
  );
}
