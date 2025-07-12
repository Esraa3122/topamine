import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    required this.title,
    super.key,
    this.backgroundColor,
    this.color,
  });

  final String title;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomLinearButton(
            width: 50,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          Flexible(
            child: TextApp(
              text: title,
              theme: context.textStyle.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeightHelper.bold,
                color: color,
              ),
              // textOverflow: TextOverflow.ellipsis,
            ),
          ),
          // const Text(''),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 70.h);
}
