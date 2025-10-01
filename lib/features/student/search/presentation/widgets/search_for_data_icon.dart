import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class SearchForDataIcon extends StatelessWidget {
  const SearchForDataIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Column(
            children: [
              SizedBox(
                height: 100.h,
              ),
              Icon(
                Icons.search_sharp,
                color: context.color.textColor,
                size: 150,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextApp(
                text: 'ابحث عن الكورسات و المعلمين',
                theme: context.textStyle.copyWith(
                  fontWeight: FontWeightHelper.bold,
                  fontSize: 18.sp,
                  fontFamily: FontFamilyHelper.cairoArabic,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
