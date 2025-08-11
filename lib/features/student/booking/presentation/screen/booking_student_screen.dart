import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/booking/presentation/cubit/booking_student_cubit.dart';
import 'package:test/features/student/booking/presentation/cubit/booking_student_state.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_statuse_list_student.dart';
import 'package:test/features/student/booking/presentation/widgets/courses_booking_list_student.dart';

class BookingStudentScreen extends StatefulWidget {
  const BookingStudentScreen({super.key});

  @override
  State<BookingStudentScreen> createState() => _BookingStudentScreenState();
}

class _BookingStudentScreenState extends State<BookingStudentScreen> {
  String selectedFilter = 'all';
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  void handleFilterChange(String value) {
    setState(() => selectedFilter = value);
  }

  void handleSearch(String value) {
    setState(() => searchQuery = value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingStudentCubit()..fetchEnrolledCourses(),
      child: BlocBuilder<BookingStudentCubit, BookingStudentState>(
        builder: (context, state) {
          if (state is BookingStudentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingStudentLoaded) {
            var filteredCourses = state.courses;

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
                  CustomTextField(
                    controller: searchController,
                    lable: 'Search',
                    hintText: 'Search for courses..',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.filter_list),
                    onChanged: handleSearch,
                  ),
                  SizedBox(height: 20.h),
                  BookingStatusListStudent(
                    selectedValue: selectedFilter,
                    onChanged: handleFilterChange,
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: CoursesBookingListStudent(courses: filteredCourses),
                  ),
                ],
              ),
            );
          } else if (state is BookingStudentError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
