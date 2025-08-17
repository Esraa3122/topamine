import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/course_details/presentation/widgets/vertical_validator.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:test/features/teacher/course_details/presentation/widgets/course_info_teacher_profile.dart';
import 'package:test/features/teacher/course_details/presentation/widgets/custom_contanier_course_teacher_profile.dart';
import 'package:test/features/teacher/course_details/presentation/widgets/lecture_item_teacher_profile.dart';

class CourseDetailsTeacherProfileBody extends StatefulWidget {
  const CourseDetailsTeacherProfileBody({required this.course, super.key});
  final CoursesModel course;

  @override
  State<CourseDetailsTeacherProfileBody> createState() =>
      _CourseDetailsTeacherProfileBodyState();
}

class _CourseDetailsTeacherProfileBodyState
    extends State<CourseDetailsTeacherProfileBody> {
  int enrolledCount = 0;

  @override
  void initState() {
    super.initState();
    fetchEnrolledCount();
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) {
      return "انتهى";
    }

    final days = duration.inDays;
    return '${days} يوم';

    // final hours = duration.inHours % 24;
    // final minutes = duration.inMinutes % 60;

    // return '${days} يوم ${hours} ساعة ${minutes} دقيقة';
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
          Stack(
            children: [
              Image.network(widget.course.imageUrl ?? ''),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContanierCourseTeacherProfile(
                      label: widget.course.subject ?? '',
                      backgroundColor: const Color(0xffDBEAFE),
                      textColor: const Color(0xff2563EB),
                    ),
                    CustomContanierCourseTeacherProfile(
                      label:
                          '${widget.course.lectures!.length.toString()} محاضره',
                      backgroundColor: const Color(0xffDCFCE7),
                      textColor: const Color(0xff16A34A),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
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
                SizedBox(width: 12.w),
                TextApp(
                  text:
                      '${context.translate(LangKeys.addedBy)} ${widget.course.teacherName}',
                  theme: context.textStyle.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeightHelper.regular,
                    color: context.color.bluePinkLight,
                  ),
                ),
                SizedBox(height: 16.h),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CourseInfoTeacherProfile(
                      icon: Icons.people,
                      label: enrolledCount.toString(),
                      sub: context.translate(LangKeys.student),
                    ),
                    const VertiDivider(),
                    CourseInfoTeacherProfile(
                      icon: Icons.access_time,
                      label: formatDuration(difference),
                      sub: context.translate(LangKeys.duration),
                    ),
                    const VertiDivider(),
                    CourseInfoTeacherProfile(
                      icon: Icons.video_collection,
                      label: widget.course.lectures!.length.toString(),
                      sub: context.translate(LangKeys.lecture),
                    ),
                  ],
                ),
                const Divider(),

                SizedBox(height: 24.h),
                TextApp(
                  text: context.translate(LangKeys.courseContent),
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                  ),
                ),
                SizedBox(height: 16.h),
                if (widget.course.lectures == null ||
                    widget.course.lectures!.isEmpty)
                  TextApp(
                    text: 'No lectures available',
                    theme: context.textStyle.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.course.lectures!.length,
                    itemBuilder: (context, index) {
                      return LectureItemTeacherProfile(
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
