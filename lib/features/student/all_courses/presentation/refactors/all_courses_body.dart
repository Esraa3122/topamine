import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/student/all_courses/data/course_service.dart';
import 'package:test/features/student/all_courses/presentation/widget/contanier_all_course.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class AllCoursesBody extends StatefulWidget {
  const AllCoursesBody({super.key});

  @override
  State<AllCoursesBody> createState() => _AllCoursesBodyState();
}

class _AllCoursesBodyState extends State<AllCoursesBody> {
  String selectedFilter = 'All';

  late final Future<List<CoursesModel>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = CourseService().getAllCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CoursesModel>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final courses = snapshot.data ?? [];
        final filters = <String>[
          'All',
          ...{
            for (final c in courses)
              if (c.gradeLevel!.isNotEmpty) c.gradeLevel!,
          },
        ];
        final filteredCourses = selectedFilter == 'All'
            ? courses
            : courses
                  .where((course) => course.gradeLevel == selectedFilter)
                  .toList();

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => SizedBox(width: 10.w),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = filter == selectedFilter;
                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => selectedFilter = filter);
                      },
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey.shade200,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: GridView.builder(
                  itemCount: filteredCourses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemBuilder: (context, index) {
                    return ContanierAllCourse(
                      course: filteredCourses[index],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
