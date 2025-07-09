import 'package:flutter/material.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/home/data/model/coures_model.dart';
import 'package:test/features/home/presentation/widgets/contanier_all_course.dart';

class AllCoursesPage extends StatefulWidget {
  const AllCoursesPage({super.key});

  @override
  State<AllCoursesPage> createState() => _AllCoursesPageState();
}

class _AllCoursesPageState extends State<AllCoursesPage> {
  String selectedFilter = 'All';

  List<CourseModel> allCourses = [
    CourseModel(
      image: AppImages.logo,
      title: 'Advanced Mathematics',
      teacher: 'Dr. James Wilson',
      enrolledDate: 'Sept 15, 2023',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'AP Physics',
      teacher: 'Prof. Emily Chen',
      enrolledDate: 'Aug 30, 2023',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'SAT Preparation',
      teacher: 'Mr. Robert Brown',
      enrolledDate: 'July 10, 2023',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'English Grammar',
      teacher: 'Ms. Sarah Clark',
      enrolledDate: 'June 5, 2023',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Courses '),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
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
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: filteredCourses.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return ContanierAllCourse(course: filteredCourses[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
