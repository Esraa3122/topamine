import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/course_detailse_for_view_profile/widget/item_lecteur_teacher.dart';

class CourseDetailseForViewProfileBody extends StatefulWidget {
  const CourseDetailseForViewProfileBody({required this.course, super.key});
  final CoursesModel course;

  @override
  State<CourseDetailseForViewProfileBody> createState() =>
      _CourseDetailseForViewProfileBodyState();
}

class _CourseDetailseForViewProfileBodyState
    extends State<CourseDetailseForViewProfileBody> {
  int enrolledCount = 0;

  @override
  void initState() {
    super.initState();
    fetchEnrolledCount();
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) return "انتهى";
    final days = duration.inDays;
    return '${days} يوم';
  }

  Future<int> getEnrolledStudentCount(String courseId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('courseId', isEqualTo: courseId)
        .get();
    return snapshot.size;
  }

  Future<void> fetchEnrolledCount() async {
    final count = await getEnrolledStudentCount(widget.course.id.toString());
    setState(() {
      enrolledCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final endDate = widget.course.endDate;
    final difference = endDate!.difference(now);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200.h,
            child: Stack(
              children: [
                Image.network(
                  widget.course.imageUrl ?? '',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Subject
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xffDBEAFE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextApp(
                          text: widget.course.subject ?? '',
                          theme: context.textStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeightHelper.medium,
                          ),
                        ),
                      ),
                      // Lectures count
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xffDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextApp(
                          text: '${widget.course.lectures!.length} محاضره',
                          theme: context.textStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeightHelper.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextApp(
                  text: widget.course.title,
                  theme: context.textStyle.copyWith(
                    fontSize: 25.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                TextApp(
                  text: widget.course.subTitle ?? '',
                  theme: context.textStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: context.color.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                TextApp(
                  text: 'تم اضافته بواسطة ${widget.course.teacherName}',
                  theme: context.textStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: context.color.bluePinkLight,
                  ),
                ),
                SizedBox(height: 16.h),
                const Divider(),
                SizedBox(height: 16.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.course.lectures!.length,
                  itemBuilder: (context, index) {
                    return ItemLecteurTeacher(
                      lecture: widget.course.lectures![index],
                      course: widget.course,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
