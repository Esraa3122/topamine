import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/features/home/presentation/widgets/auto_slider.dart';
import 'package:test/features/home/presentation/widgets/course_for_you.dart';
import 'package:test/features/home/presentation/widgets/progress_badges.dart';
import 'package:test/features/home/presentation/widgets/teachers_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xffF3F4F6),
                  labelText: 'Search teacher or subject ',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: const Icon(Icons.filter_list),
                ),
              ),
              SizedBox(height: 20.h),
              const BannerSliders(),
              SizedBox(height: 20.h),
              // CategoryList(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Courses For You',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRoutes.allCoursesPage);
                    },
                    child: Text(
                      'View all',
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              CoursesListYou(),
              SizedBox(height: 20.h),
              const Text('Featured Teachers'),
              const Text('Top-rated tutors this week'),
              SizedBox(height: 16.h),
              const TeachersList(),
              SizedBox(height: 24.h),
              const StudentTestimonials(),
            ],
          ),
        ],
      ),
    );
  }
}
