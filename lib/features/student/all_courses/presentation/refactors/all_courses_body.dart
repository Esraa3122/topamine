import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/all_courses/presentation/widget/contanier_all_course.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';

class AllCoursesBody extends StatefulWidget {
  const AllCoursesBody({super.key});

  @override
  State<AllCoursesBody> createState() => _AllCoursesBodyState();
}

class _AllCoursesBodyState extends State<AllCoursesBody> {
   String selectedFilter = 'All';

  List<CourseModel> allCourses = [
    CourseModel(
      image: AppImages.logo,
      title: 'Advanced Mathematics',
      teacher: 'Dr.James Wilson',
      enrolledDate: 'Sept 15, 2023',
      status: 'Completed 50%',
      subject: 'Mathematics',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'AP Physics',
      teacher: 'Prof. Emily Chen',
      enrolledDate: 'Aug 30, 2023',
      status: 'Completed 80%',
      subject: 'Physics',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'SAT Preparation',
      teacher: 'Mr. Robert Brown',
      enrolledDate: 'July 10, 2023',
      status: 'Completed 60%',
      subject: 'SAT',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'English Grammar',
      teacher: 'Ms. Sarah Clark',
      enrolledDate: 'June 5, 2023',
      status: 'Completed 50%',
      subject: 'English',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'English Grammar',
      teacher: 'Ms. Sarah Clark',
      enrolledDate: 'June 5, 2023',
      status: 'Completed 50%',
      subject: 'English',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'English Grammar',
      teacher: 'Ms. Sarah Clark',
      enrolledDate: 'June 5, 2023',
      status: 'Completed 50%',
      subject: 'English',
    ),
  ];

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