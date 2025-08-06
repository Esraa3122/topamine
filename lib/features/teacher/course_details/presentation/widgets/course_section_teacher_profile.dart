import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class CourseSectionTeacherProfile extends StatefulWidget {
  const CourseSectionTeacherProfile({
    required this.title,
    required this.subtitle,
    required this.contents,
    super.key,
  });
  final String title;
  final String subtitle;
  final List<String> contents;

  @override
  State<CourseSectionTeacherProfile> createState() => _CourseSectionTeacherProfileState();
}

class _CourseSectionTeacherProfileState extends State<CourseSectionTeacherProfile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: context.color.mainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: TextApp(
          text: widget.title,
          theme: context.textStyle.copyWith(
            fontWeight: FontWeightHelper.bold,
            color: context.color.textColor,
          ),
        ),
        subtitle: TextApp(
          text: widget.subtitle,
          theme: context.textStyle.copyWith(
            fontWeight: FontWeightHelper.regular,
            color: context.color.textColor,
          ),
        ),
        trailing: Icon(
          _expanded ? Icons.expand_less : Icons.expand_more,
          color: context.color.textColor,
        ),
        onExpansionChanged: (value) {
          setState(() {
            _expanded = value;
          });
        },
        children: widget.contents
            .map(
              (content) => ListTile(
                title: TextApp(
                  text: content,
                  theme: context.textStyle.copyWith(
                    fontWeight: FontWeightHelper.regular,
                    color: context.color.textColor,
                  ),
                ),
                dense: true,
                leading: Icon(
                  Icons.play_circle_outline,
                  size: 20.sp,
                  color: context.color.textColor,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
