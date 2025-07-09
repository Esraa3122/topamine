import 'package:flutter/material.dart';
import 'package:test/features/student/profile/presentation/widgets/profile_property.dart';

class CustomShapeProfile extends StatelessWidget {
  final String image;
  final String name;
  final String? title;
  final List<ProfileProperty> properties;

  const CustomShapeProfile({
    super.key,
    required this.image,
    required this.name,
    this.title,
    required this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(minRadius: 50, backgroundImage: AssetImage(image)),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (title != null) ...[
              const SizedBox(height: 6),
              Text(
                title!,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
            const SizedBox(height: 12),
            Column(
              children:
                  properties.map((prop) {
                    return ProfileProperty(icon: prop.icon, text: prop.text);
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
