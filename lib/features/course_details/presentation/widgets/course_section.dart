import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseSection extends StatefulWidget {
  const CourseSection({
    required this.title,
    required this.subtitle,
    required this.contents,
    super.key,
  });
  final String title;
  final String subtitle;
  final List<String> contents;

  @override
  State<CourseSection> createState() => _CourseSectionState();
}

class _CourseSectionState extends State<CourseSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(widget.subtitle),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (value) {
          setState(() {
            _expanded = value;
          });
        },
        children: widget.contents
            .map(
              (content) => ListTile(
                title: Text(content),
                dense: true,
                leading: Icon(Icons.play_circle_outline, size: 20.sp),
              ),
            )
            .toList(),
      ),
    );
  }
}
