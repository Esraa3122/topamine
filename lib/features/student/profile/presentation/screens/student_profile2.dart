import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/profile/presentation/widgets/course_list.dart';
import 'package:test/features/student/profile/presentation/widgets/custom_shape_profile.dart';
import 'package:test/features/student/profile/presentation/widgets/profile_property.dart';

class StudentProfile2 extends StatelessWidget {
  const StudentProfile2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              image: AppImages.logo,
              name: 'Sarah',
              properties: [
                ProfileProperty(icon: Icons.mail, text: 'example@gmail.com'),
                ProfileProperty(icon: Icons.phone, text: '+1-555-123-4567'),
                ProfileProperty(
                  icon: Icons.location_on_outlined,
                  text: 'New York',
                ),
                ProfileProperty(icon: Icons.school, text: '11th Grade'),
              ],
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'My Courses',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 30.h),
            CoursesList(),
          ],
        ),
      ),
    );
  }
}
