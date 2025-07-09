import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/images/app_images.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Topamine'),
            const Spacer(),
            Image.asset(AppImages.logo, width: 50, height: 50),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
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
                const SizedBox(height: 20),
                const BannerSliders(),
                const SizedBox(height: 20),
                // CategoryList(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Courses For You',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushNamed(AppRoutes.allCoursesPage);
                      },
                      child: const Text(
                        'View all',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                CoursesListYou(),
                const SizedBox(height: 20),
                const Text('Featured Teachers'),
                const Text('Top-rated tutors this week'),
                const SizedBox(height: 16),
                const TeachersList(),
                const SizedBox(height: 24),
                const StudentTestimonials(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
