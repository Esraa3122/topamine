import 'package:flutter/material.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/booking/presentation/widgets/BookingCategoryList.dart';
import 'package:test/features/booking/presentation/widgets/courses_booking_list.dart';
import 'package:test/features/home/data/model/coures_model.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedFilter = 'all';
  String searchQuery = '';

  List<CourseModel> allCourses = [
    CourseModel(
      image: AppImages.logo,
      title: 'Advanced Mathematics',
      teacher: 'Dr. James Wilson',
      enrolledDate: 'Sept 15, 2023',
      status: 'inprogress',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'AP Physics',
      teacher: 'Prof. Emily Chen',
      enrolledDate: 'Aug 30, 2023',
      status: 'completed',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'SAT Preparation',
      teacher: 'Mr. Robert Brown',
      enrolledDate: 'July 10, 2023',
      status: 'completed',
    ),
  ];

  void handleFilterChange(String value) {
    setState(() {
      selectedFilter = value;
    });
  }

  void handleSearch(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var filteredCourses =
        selectedFilter == 'all'
            ? allCourses
            : allCourses
                .where((course) => course.status == selectedFilter)
                .toList();
    if (searchQuery.isNotEmpty) {
      final lower = searchQuery.toLowerCase();
      filteredCourses =
          filteredCourses.where((course) {
            return course.title.toLowerCase().contains(lower) ||
                course.teacher.toLowerCase().contains(lower) ||
                (course.subject?.toLowerCase() ?? '').contains(lower);
          }).toList();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'My Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: handleSearch,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color(0xffF3F4F6),
                labelText: 'Search for courses..',
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            BookingCategoryList(
              selectedValue: selectedFilter,
              onChanged: handleFilterChange,
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  filteredCourses.isEmpty
                      ? const Center(child: Text('No courses found'))
                      : CoursesBokkingList(courses: filteredCourses),
            ),
          ],
        ),
      ),
    );
  }
}
