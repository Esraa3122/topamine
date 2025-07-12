import 'package:flutter/material.dart';
import 'package:test/core/style/images/app_images.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets({
    required this.mainLight,
    // required this.mainDark,
    required this.testImage,
  });

  final String? mainLight;
  // final String? mainDark;
  final String? testImage;

  @override
  ThemeExtension<MyAssets> copyWith({
    String? mainLight,
    // String? mainDark,
    String? testImage,
  }) {
    return MyAssets(
      mainLight: mainLight,
      // mainDark: mainDark,
      testImage: testImage,
    );
  }

  @override
  ThemeExtension<MyAssets> lerp(
    covariant ThemeExtension<MyAssets>? other,
    double t,
  ) {
    if (other is! MyAssets) {
      return this;
    }
    return MyAssets(
      mainLight: mainLight,
      // mainDark: mainDark,
      testImage: testImage
    );
  }

  static const MyAssets dark = MyAssets(
    mainLight: AppImages.mainDark,
    // mainDark: AppImages.mainLight,
    testImage: AppImages.onbording1,
  );
  static const MyAssets light = MyAssets(
    mainLight: AppImages.mainLight,
    // mainDark: AppImages.mainDark,
    testImage: AppImages.onbording2
  );
}
