import 'package:flutter/material.dart';

class CourseSection extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<String> contents;

  const CourseSection({super.key, 
    required this.title,
    required this.subtitle,
    required this.contents,
  });

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
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        children:
            widget.contents
                .map(
                  (content) => ListTile(
                    title: Text(content),
                    dense: true,
                    leading: const Icon(Icons.play_circle_outline, size: 20),
                  ),
                )
                .toList(),
      ),
    );
  }
}
