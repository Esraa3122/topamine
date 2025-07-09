import 'package:flutter/material.dart';
import 'package:test/features/student/profile/presentation/widgets/course_list.dart';
import 'package:test/features/student/profile/presentation/widgets/custom_shape_profile.dart';
import 'package:test/features/student/profile/presentation/widgets/profile_property.dart';

class TeacherProfile2 extends StatelessWidget {
  const TeacherProfile2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomShapeProfile(
              image: 'assets/images/Mathematics-Hero-1600x900.jpg',
              name: 'Sarah Anderson',
              title: 'Mathematics & Physics Expert',
              properties: [
                ProfileProperty(icon: Icons.mail, text: 'example@gmail.com'),
                ProfileProperty(icon: Icons.phone, text: '+1 (555) 123-4567'),
                ProfileProperty(
                  icon: Icons.location_on_outlined,
                  text: 'New York',
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'My Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 30),
            CoursesList(),
          ],
        ),
      ),
    );
  }
}
