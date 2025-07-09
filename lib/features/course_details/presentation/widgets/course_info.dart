import 'package:flutter/material.dart';

class CourseInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  const CourseInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(sub, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
