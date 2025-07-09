import 'package:flutter/material.dart';
import 'package:test/core/style/images/app_images.dart';

class MyAssets extends ThemeExtension<MyAssets> {
  const MyAssets({
    // required this.bigNavBar,
    // required this.homeBg,
    required this.testImage,
  });

  // final String? bigNavBar;
  // final String? homeBg;
  final String? testImage;

  @override
  ThemeExtension<MyAssets> copyWith({
    // String? bigNavBar,
    // String? homeBg,
    String? testImage,
  }) {
    return MyAssets(
      // bigNavBar: bigNavBar,
      // homeBg: homeBg,
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
      // bigNavBar: bigNavBar,
      // homeBg: homeBg,
      testImage: testImage
    );
  }

  static const MyAssets dark = MyAssets(
    // bigNavBar: AppImages.bigNavBarDark,
    // homeBg: AppImages.homeBgDark,
    testImage: AppImages.onbording1,
  );
  static const MyAssets light = MyAssets(
    // bigNavBar: AppImages.bigNavBarLight,
    // homeBg: AppImages.homeBgLight,
    testImage: AppImages.onbording2
  );
}
