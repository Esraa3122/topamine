import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_shimmer_card.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/edit_courses/screen/edit_courses_teacher_screen.dart';

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
    return courses.where('teacherId', isEqualTo: currentId).snapshots();
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
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
          return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 5,
              itemBuilder: (context, index) => const BookingCourseShimmerCard(),
            );
        }

        final filteredDocs = snapshot.data!.docs.where((doc) {
          final course = doc.data() as Map<String, dynamic>;
          final query = widget.searchQuery.toLowerCase();

          final startDate = (course['startDate'] as Timestamp).toDate();
          final endDate = (course['endDate'] as Timestamp).toDate();
          final now = DateTime.now();

          final isActive = now.isAfter(startDate) && now.isBefore(endDate);

          if (widget.selectedFilter == 'active' && !isActive) return false;
          if (widget.selectedFilter == 'not active' && isActive) return false;

          return course['title'].toString().toLowerCase().contains(query) ||
              course['teacherName'].toString().toLowerCase().contains(query) ||
              course['gradeLevel'].toString().toLowerCase().contains(query);
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(child: Text('لا يوجد كورسات مضافة'));
        }

        return SizedBox(
          height: 600.h,
          child: ListView(
            children: filteredDocs.map((DocumentSnapshot document) {
              Map<String, dynamic> course =
                  document.data()! as Map<String, dynamic>;

              final startDate = (course['startDate'] as Timestamp).toDate();
              final endDate = (course['endDate'] as Timestamp).toDate();
              final now = DateTime.now();

              final isActive = now.isAfter(startDate) && now.isBefore(endDate);
              final courseStatus = isActive ? "Active" : "Not Active";

              final Color statusShadowColor = courseStatus == 'Active'
                  ? Colors.green.withOpacity(0.3)
                  : Colors.red.withOpacity(0.3);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),

                  gradient: LinearGradient(
                    colors: [
                      context.color.mainColor!,
                      context.color.mainColor!.withOpacity(0.8),
                    ],
                    begin: const Alignment(0.36, 0.27),
                    end: const Alignment(0.58, 0.85),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusShadowColor,
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                    BoxShadow(
                      color: statusShadowColor,
                      offset: const Offset(0, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    final courseModel = CoursesModel.fromJson({
                      'id': document.id,
                      ...course,
                    });
                    context.pushNamed(
                      AppRoutes.courseDetailsTeacherProfile,
                      arguments: courseModel,
                    );
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            course['imageUrl']?.toString() ?? '',
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: context.color.textColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  course['gradeLevel'].toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: context.color.textColor,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'تاريخ البداية: ${_formatTime((course['createdAt'] as Timestamp?)?.toDate())}',
                                  style: const TextStyle(color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'تاريخ الانتهاء: ${_formatTime((course['endDate'] as Timestamp?)?.toDate())}',
                                  style: const TextStyle(color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  courseStatus,
                                  style: TextStyle(
                                    color: isActive ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),                               
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditCoursesTeacherScreen(
                                      coursesModel: CoursesModel.fromJson({
                                        'id': document.id,
                                        ...course,
                                      }),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit, color: Colors.amber),
                            ),
                            SizedBox(height: 8.h),
                            IconButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('courses')
                                    .doc(document.id)
                                    .delete()
                                    .then((_) {
                                      AwesomeSnackBar.show(
                                        context: context,
                                        title: 'Success!',
                                        message: 'تمت حذف الكورس بنجاح',
                                        contentType: ContentType.success,
                                      );
                                    })
                                    .catchError((error) {
                                      AwesomeSnackBar.show(
                                        context: context,
                                        title: 'Error!',
                                        message: 'حدث خطأ أثناء حذف الكورس',
                                        contentType: ContentType.failure,
                                      );
                                    });
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
