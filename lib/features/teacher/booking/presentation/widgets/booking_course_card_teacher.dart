import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/loading/empty_screen.dart';
import 'package:test/core/common/toast/awesome_snackbar.dart';
import 'package:test/core/common/toast/buildawesomedialog.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/booking/presentation/widgets/booking_course_shimmer_card.dart';
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
  // double _scale = 1;

  Stream<QuerySnapshot> getCoursesStream() {
    final courses = FirebaseFirestore.instance.collection('courses');
    final currentId = FirebaseAuth.instance.currentUser!.uid;
    return courses.where('teacherId', isEqualTo: currentId).snapshots();
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) return 'انتهى';
    final days = duration.inDays;
    return '$days يوم';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getCoursesStream(),
      builder: (context, snapshot) {
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
          final course = doc.data()! as Map<String, dynamic>;
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
          return const EmptyScreen(
            title: 'لا توجد دورات متاحة',
          );
        }

        return SizedBox(
          height: 600.h,
          child: ListView(
            children: filteredDocs.map((doc) {
              final course = doc.data()! as Map<String, dynamic>;
              final startDate = (course['startDate'] as Timestamp).toDate();
              final endDate = (course['endDate'] as Timestamp).toDate();
              final now = DateTime.now();
              final isActive = now.isAfter(startDate) && now.isBefore(endDate);
              final courseStatus = isActive ? 'نشط' : 'غير نشط';
              // final difference = endDate.difference(now);

              final statusColor = isActive ? Colors.green : Colors.grey;

              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  final courseModel = CoursesModel.fromJson({
                    'id': doc.id,
                    ...course,
                  });
                  context.pushNamed(
                    AppRoutes.courseDetails,
                    arguments: courseModel,
                  );
                },
                child: Container(
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
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    course['imageUrl'].toString(),
                                    width: 80.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                // Badge
                                Positioned(
                                  top: 6,
                                  left: 6,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: TextApp(
                                      text: courseStatus,
                                      theme: context.textStyle.copyWith(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeightHelper.bold,
                                        fontFamily:
                                            FontFamilyHelper.cairoArabic,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextApp(
                                    text: course['title'].toString(),
                                    maxLines: 1,
                                    textOverflow: TextOverflow.ellipsis,
                                    theme: context.textStyle.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeightHelper.bold,
                                      fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  TextApp(
                                    text: course['gradeLevel'].toString(),
                                    theme: context.textStyle.copyWith(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeightHelper.medium,
                                      color: context.color.textColor,
                                      fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  // SizedBox(height: 4.h),
                                  // Row(
                                  //   children: [
                                  //     Chip(
                                  //       label: Row(
                                  //         children: [
                                  //           const Icon(
                                  //             Icons.timer,
                                  //             size: 14,
                                  //             color: Colors.white,
                                  //           ),
                                  //           const SizedBox(width: 4),
                                  //           Text(
                                  //             difference.isNegative
                                  //                 ? 'انتهى'
                                  //: 'ينتهي خلال ${formatDuration(difference)}',
                                  //             style: TextStyle(
                                  //               fontSize: 11.sp,
                                  //               color: Colors.white,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //       backgroundColor:
                                  //           difference.inDays <= 0
                                  //               ? Colors.red.shade400
                                  //               : (difference.inDays <= 7
                                  //                   ? Colors.orange.shade400
                                  //                   : Colors.grey.shade400),
                                  //       padding: EdgeInsets.zero,
                                  //       side: const BorderSide(
                                  //         color: Colors.transparent,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(height: 10.h),
                                  TextApp(
                                    text:
                                        '${context.translate(LangKeys.startDate)} ${_formatTime(startDate)}',
                                    theme: context.textStyle.copyWith(
                                      color: context.color.textColor!
                                          .withOpacity(0.3),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeightHelper.regular,
                                      fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  TextApp(
                                    text:
                                        '${context.translate(LangKeys.endDate)} ${_formatTime(endDate)}',
                                    theme: context.textStyle.copyWith(
                                      color: context.color.textColor!
                                          .withOpacity(0.3),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeightHelper.regular,
                                      fontFamily: FontFamilyHelper.cairoArabic,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.grey),
                              elevation: 4,
                              color: context.color.mainColor,
                              shadowColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              position: PopupMenuPosition.under,
                              offset:  const Offset(0, 0),
                              onSelected: (value) {
                                if (value == 'edit') {
                                  context.pushNamed(
                                    AppRoutes.editCoursesTeacherScreen,
                                    arguments: CoursesModel.fromJson({
                                      'id': doc.id,
                                      ...course,
                                    }),
                                  );
                                } else if (value == 'delete') {
                                  buildAwesomeDialogWarning2(
                                    'هل أنت متأكد من الحذف؟',
                                    'لن تتمكن من استعادة هذه الدورة بعد الحذف.',
                                    context,
                                    () {
                                      FirebaseFirestore.instance
                                          .collection('courses')
                                          .doc(doc.id)
                                          .delete()
                                          .then((_) {
                                            AwesomeSnackBar.show(
                                              context: context,
                                              title: 'تم الحذف',
                                              message: 'تم حذف الدورة بنجاح',
                                              contentType: ContentType.success,
                                            );
                                          })
                                          .catchError((error) {
                                            AwesomeSnackBar.show(
                                              context: context,
                                              title: 'Error!',
                                              message: 'حدث خطأ أثناء الحذف',
                                              contentType: ContentType.failure,
                                            );
                                          });
                                    },
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.edit, color: Colors.amber, size: 18),
                                      ),
                                      const SizedBox(width: 10),
                                      TextApp(
                                        text: 'تعديل',
                                        theme: context.textStyle.copyWith(
                                          fontWeight: FontWeightHelper.medium,
                                          fontSize: 14,
                                          fontFamily: FontFamilyHelper.cairoArabic,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.delete, color: Colors.red, size: 18),
                                      ),
                                      const SizedBox(width: 10),
                                      TextApp(
                                        text: 'حذف',
                                        theme: context.textStyle.copyWith(
                                          fontWeight: FontWeightHelper.medium,
                                          fontSize: 14,
                                          fontFamily: FontFamilyHelper.cairoArabic,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                      ),
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
