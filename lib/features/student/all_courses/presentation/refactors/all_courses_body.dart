import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/all_courses/presentation/widget/contanier_all_course.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';

class AllCoursesBody extends StatefulWidget {
  const AllCoursesBody({super.key});

  @override
  State<AllCoursesBody> createState() => _AllCoursesBodyState();
}

class _AllCoursesBodyState extends State<AllCoursesBody> {

  final List<CoursesModel> allCourses = [
    CoursesModel(
      id: '1',
      title: 'Mathematics',
      teacherName: 'Dr. Ahmed',
      imageUrl: AppImages.backButton,
    ),
    CoursesModel(
      id: '2',
      title: 'Physics',
      teacherName: 'Dr. Sara',
      imageUrl: AppImages.backButton,
    ),
    CoursesModel(
      id: '3',
      title: 'English Literature',
      teacherName: 'Mr. John',
      imageUrl: AppImages.backButton,
    ),
  ];
  String selectedFilter = 'All';
  List<String> filters = ['All', 'Mathematics', 'Physics', 'English'];
  @override
  Widget build(BuildContext context) {
     final filteredCourses = selectedFilter == 'All'
        ? allCourses
        : allCourses
              .where((course) => course.title.contains(selectedFilter))
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
                      setState(() {
                        selectedFilter = filter;
                      });
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
                  return ContanierAllCourse(course: filteredCourses[index]);
                },
              ),
            ),
          ],
        ),
      );
  }
}