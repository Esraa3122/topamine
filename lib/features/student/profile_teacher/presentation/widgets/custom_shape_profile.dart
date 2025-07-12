import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/profile_teacher/presentation/widgets/profile_property.dart';

class CustomShapeProfile extends StatelessWidget {
  const CustomShapeProfile({
    required this.image,
    required this.name,
    required this.properties,
    super.key,
    this.title,
  });

  final String image;
  final String name;
  final String? title;
  final List<ProfileProperty> properties;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 60.h),
          padding: EdgeInsets.only(
            top: 60.h,
            left: 16.w,
            right: 16.w,
            bottom: 16.h,
          ),
          decoration: BoxDecoration(
            color: context.color.mainColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              TextApp(
                    text: name,
                    theme: context.textStyle.copyWith(
                      fontSize: 20.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: context.color.textColor
                    ),
                  ),
              if (title != null) ...[
                SizedBox(height: 6.h),
                TextApp(
                    text: title!,
                    theme: context.textStyle.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeightHelper.regular,
                      color: Colors.grey
                    ),
                  ),
              ],
              SizedBox(height: 12.h),
              Column(
                children: properties.map((prop) {
                  return ProfileProperty(icon: prop.icon, text: prop.text);
                }).toList(),
              ),
            ],
          ),
        ),

        Positioned(
          top: 0,
          child: CircleAvatar(
            backgroundColor: context.color.textColor,
            radius: 52,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(image),
              backgroundColor: context.color.mainColor,
            ),
          ),
        ),
      ],
    );
  }
}
