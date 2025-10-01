import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.iconColor,
    required this.icon,
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.badgeCount = 0,
    this.onTap,
  });
  final Color iconColor;
  final Widget icon;
  final String? title;
  final String? subtitle;
  final Widget? titleWidget;
  final int badgeCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomFadeInRight(
      duration: 400,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: context.color.mainColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: icon,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      top: -5,
                      right: -5,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: TextApp(
                          text: badgeCount.toString(),
                          theme: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            fontWeight: FontWeightHelper.bold,
                            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child:
                    titleWidget ??
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title != null)
                          TextApp(
                            text: title!,
                            theme: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeightHelper.medium,
                              color: context.color.textColor,
                              fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
                            ),
                          ),
                        if (subtitle != null) SizedBox(height: 4.h),
                        if (subtitle != null)
                          TextApp(
                            text: subtitle!,
                            theme: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeightHelper.regular,
                              color: Colors.grey[600],
                              fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
                            ),
                          ),
                      ],
                    ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: context.color.textColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
