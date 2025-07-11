import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';
import 'package:test/features/teacher/booking/presentation/widgets/booking_statuse_list_teacher.dart';
import 'package:test/features/teacher/booking/presentation/widgets/courses_booking_list_teacher.dart';

class BookingTeacherScreen extends StatefulWidget {
  const BookingTeacherScreen({super.key});

  @override
  State<BookingTeacherScreen> createState() => _BookingTeacherScreenState();
}

class _BookingTeacherScreenState extends State<BookingTeacherScreen> {
   String selectedFilter = 'all';
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextApp(
            text: 'My Courses',
            theme: context.textStyle.copyWith(
              color: context.color.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeightHelper.medium,
            ),
          ),
          SizedBox(height: 10.h),
          CustomFadeInLeft(
            duration: 300,
            child: CustomTextField(
              controller: searchController,
              lable: 'Search',
              hintText: 'Search for courses..',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.filter_list),
              onChanged: handleSearch,
            ),
          ),
          SizedBox(height: 20.h),
          BookingStatusListTeacher(
            selectedValue: selectedFilter,
            onChanged: handleFilterChange,
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: Text('No courses found'))
                : CoursesBookingListTeacher(courses: filteredCourses),
          ),
        ],
      ),
    );
  }
}
