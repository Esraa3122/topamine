import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/style/images/app_images.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomShapeProfile(
                image: AppImages.logo,
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
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'My Courses',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              CoursesList(),
            ],
          ),
        ),
      ),
    );
  }
}
