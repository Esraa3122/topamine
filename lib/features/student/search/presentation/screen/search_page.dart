import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_card_student.dart';
import 'package:test/features/student/home/data/model/courses_model.dart';
import 'package:test/features/student/search/presentation/widgets/custom_text_search.dart';
import 'package:test/features/student/search/presentation/widgets/subject_filter_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedSubject = 'All';
  String searchQuery = '';

  List<CoursesModel> allCourses = [];
  List<String> sectionTitles = ['All'];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCoursesFromFirestore();
  }

  Future<void> fetchCoursesFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .get();

      final loadedCourses = snapshot.docs
          .map((doc) => CoursesModel.fromJson(doc.data(), doc.id))
          .toList();

      final sections = loadedCourses
          .map((course) => course.sectionTitle)
          .where((title) => title.isNotEmpty)
          .toSet()
          .toList();

      setState(() {
        allCourses = loadedCourses;
        sectionTitles = ['All', ...sections];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching courses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<CourseModel> filteredCourses = allCourses.where((course) {
      final lowerSearch = searchQuery.toLowerCase();
      final matchSearch =
          course.title.toLowerCase().contains(lowerSearch) ||
          course.teacherEmail.toLowerCase().contains(lowerSearch) ||
          course.sectionTitle.toLowerCase().contains(lowerSearch);
      final matchSection =
          selectedSubject == 'All' || course.sectionTitle == selectedSubject;

      return matchSearch && matchSection;
    }).toList();

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
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
                        searchQuery = value ?? '';
                      });
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                SubjectFilterList(
                  sections: sectionTitles,
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
                            return BookingCourseCardStudent(
                              course: filteredCourses[index],
                            );
                          },
                        ),
                ),
              ],
            ),
          );
  }
}
