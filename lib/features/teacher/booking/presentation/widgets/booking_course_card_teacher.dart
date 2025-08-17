import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';


class BookingCourseCardTeacher extends StatefulWidget {
  const BookingCourseCardTeacher({
    required this.selectedFilter,
    required this.searchQuery,
    super.key,
  });
  final String selectedFilter;
  final String searchQuery;

  @override
  State<BookingCourseCardTeacher> createState() =>
      _BookingCourseCardTeacherState();
}

class _BookingCourseCardTeacherState extends State<BookingCourseCardTeacher> {
  Stream<QuerySnapshot> getCoursesStream() {
    final courses = FirebaseFirestore.instance.collection('courses');
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    if (widget.selectedFilter == 'all') {
      return courses.where('teacherId', isEqualTo: currentId).snapshots();
    } else {
      return courses
          .where('teacherId', isEqualTo: currentId)
          .where('gradeLevel', isEqualTo: widget.selectedFilter)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getCoursesStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }

        final filteredDocs = snapshot.data!.docs.where((doc) {
          final course = doc.data() as Map<String, dynamic>;
          final query = widget.searchQuery.toLowerCase();

          return course['subTitle'].toString().toLowerCase().contains(query) ||
              course['teacherName'].toString().toLowerCase().contains(query) ||
              course['gradeLevel'].toString().toLowerCase().contains(query);
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text('No courses found.'));
        }

        return SizedBox(
  height: 600.h,
  child: ListView(
    children: filteredDocs.map((DocumentSnapshot document) {
      Map<String, dynamic> course =
          document.data()! as Map<String, dynamic>;

      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 212, 211, 211).withOpacity(0.8),
              context.color.mainColor!.withOpacity(0.8),
            ],
            begin: const Alignment(0.36, 0.27),
            end: const Alignment(0.58, 0.85),
          ),
          boxShadow: [
            BoxShadow(
              color: context.color.containerShadow1!.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
            BoxShadow(
              color: context.color.containerShadow2!.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  course['imageUrl']!.toString(),
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'].toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        course['teacherName'].toString(),
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        course['gradeLevel'].toString(),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  ),
);

      });}}