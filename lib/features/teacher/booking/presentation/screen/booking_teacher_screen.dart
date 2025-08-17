import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/common/widgets/custom_text_field.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/add_courses/data/repo/add_course_repository.dart';
import 'package:test/features/teacher/add_courses/presentation/cubit/add_course_cubit.dart';
import 'package:test/features/teacher/add_courses/presentation/screen/add_courses_screen.dart';
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
  CoursesModel? course;

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
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
         backgroundColor: context.color.bluePinkLight,
        shape: const CircleBorder(),
        onPressed: () {
                    Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => AddCourseCubit(AddCourseRepository()),
                child: const AddCourseScreen(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFadeInLeft(
              duration: 300,
              child: CustomTextField(
                controller: searchController,
                lable: 'البحث',
                hintText: 'البحث عن الكورسات..',
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
              child: CoursesBookingListTeacher(
                selectedFilter: selectedFilter,
                searchQuery: searchQuery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
