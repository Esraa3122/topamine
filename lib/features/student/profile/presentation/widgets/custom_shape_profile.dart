import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/student/profile/presentation/widgets/profile_property.dart';

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
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(minRadius: 50, backgroundImage: AssetImage(image)),
            SizedBox(height: 12.h),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
            ),
            if (title != null) ...[
              SizedBox(height: 6.h),
              Text(
                title!,
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
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
    );
  }
}
