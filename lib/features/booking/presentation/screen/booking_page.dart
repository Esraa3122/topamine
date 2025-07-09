import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/booking/presentation/widgets/BookingCategoryList.dart';
import 'package:test/features/booking/presentation/widgets/courses_booking_list.dart';
import 'package:test/features/home/data/model/coures_model.dart';
import 'package:test/features/search/presentation/widgets/custom_text_search.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController searchController = TextEditingController();
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
    var filteredCourses = selectedFilter == 'all'
        ? allCourses
        : allCourses
              .where((course) => course.status == selectedFilter)
              .toList();
    if (searchQuery.isNotEmpty) {
      final lower = searchQuery.toLowerCase();
      filteredCourses = filteredCourses.where((course) {
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
            Text(
              'My Courses',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),
            CustomFadeInLeft(
              duration: 300,
              child: CustomTextSearch(
                searchController: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value!;
                  });
                  return null;
                },
              ),
            ),
            SizedBox(height: 20.h),
            BookingCategoryList(
              selectedValue: selectedFilter,
              onChanged: handleFilterChange,
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: filteredCourses.isEmpty
                  ? const Center(child: Text('No courses found'))
                  : CoursesBokkingList(courses: filteredCourses),
            ),
          ],
        ),
      ),
    );
  }
}
