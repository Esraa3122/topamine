import 'package:flutter/material.dart';

class ProfileProperty extends StatelessWidget {
  final IconData icon;
  final String text;

  const ProfileProperty({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [Icon(icon, size: 16), const SizedBox(width: 8), Text(text)],
      ),
    );
  }
}
