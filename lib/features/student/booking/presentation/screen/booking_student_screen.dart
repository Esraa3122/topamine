import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_statuse_list_student.dart';
import 'package:test/features/student/booking/presentation/widgets/courses_booking_list_student.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class BookingStudentScreen extends StatefulWidget {
  const BookingStudentScreen({super.key});

  @override
  State<BookingStudentScreen> createState() => _BookingStudentScreenState();
}

class _BookingStudentScreenState extends State<BookingStudentScreen> {
  String selectedFilter = 'all';
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  List<CoursesModel> allCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnrolledCourses();
  }

  Future<void> fetchEnrolledCourses() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final enrollmentSnapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('userId', isEqualTo: currentUserId)
        .get();

    final enrolledCourseIds = enrollmentSnapshot.docs
        .map((doc) => doc['courseId'] as String)
        .toList();

    final courseSnapshot =
        await FirebaseFirestore.instance.collection('courses').get();

    allCourses = courseSnapshot.docs
        .map((doc) => CoursesModel.fromJson({...doc.data(), 'id': doc.id}))
        .where((course) => enrolledCourseIds.contains(course.id))
        .toList();

    setState(() {
      isLoading = false;
    });
  }

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var filteredCourses = allCourses;

    if (selectedFilter != 'all') {
      filteredCourses = filteredCourses
          .where((course) => course.status == selectedFilter)
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      final lower = searchQuery.toLowerCase();
      filteredCourses = filteredCourses.where((course) {
        return course.title.toLowerCase().contains(lower) ||
            course.teacherName.toLowerCase().contains(lower) ||
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
          BookingStatusListStudent(
            selectedValue: selectedFilter,
            onChanged: handleFilterChange,
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: CoursesBookingListStudent(
              courses: filteredCourses,
            ),
          ),
        ],
      ),
    );
  }
}
