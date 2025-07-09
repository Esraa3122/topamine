import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/booking/presentation/widgets/course_card.dart';
import 'package:test/features/home/data/model/coures_model.dart';
import 'package:test/features/search/presentation/widgets/custom_text_search.dart';
import 'package:test/features/search/presentation/widgets/subject_filter_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedSubject = 'All';
  String searchQuery = '';

  final List<CourseModel> allCourses = [
    CourseModel(
      image: AppImages.logo,
      title: 'Advanced Mathematics',
      teacher: 'Dr. James Wilson',
      enrolledDate: 'Sept 15, 2023',
      status: 'inprogress',
      subject: 'Mathematics',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'English Writing',
      teacher: 'Mr. John Smith',
      enrolledDate: 'Aug 10, 2023',
      status: 'completed',
      subject: 'English',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'Science Basics',
      teacher: 'Prof. Emily Chen',
      enrolledDate: 'Jul 5, 2023',
      status: 'inprogress',
      subject: 'Science',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'World History',
      teacher: 'Dr. Alan Rickman',
      enrolledDate: 'Jul 1, 2023',
      status: 'completed',
      subject: 'History',
    ),
    CourseModel(
      image: AppImages.logo,
      title: 'Art Theory',
      teacher: 'Ms. Lisa Rivera',
      enrolledDate: 'Jun 20, 2023',
      status: 'inprogress',
      subject: 'Art',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var filteredCourses = selectedSubject == 'All'
        ? allCourses
        : allCourses
              .where((course) => course.subject == selectedSubject)
              .toList();
    if (searchQuery.isNotEmpty) {
      filteredCourses = filteredCourses.where((course) {
        final lower = searchQuery.toLowerCase();
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
            SubjectFilterList(
              selectedSubject: selectedSubject,
              onSubjectSelected: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: filteredCourses.isEmpty
                  ? const Center(child: Text('No courses found'))
                  : ListView.builder(
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(course: filteredCourses[index]);
                      },
                    ),
            ),
          ],
        ),
    );
  }
}
