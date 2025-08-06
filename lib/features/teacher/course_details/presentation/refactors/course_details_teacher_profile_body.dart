import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/service/paymob_manager/paymob_manager.dart';
import 'package:test/core/service/paymob_manager/webview.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/course_details/presentation/widgets/bullet_item.dart';
import 'package:test/features/student/course_details/presentation/widgets/student_course.dart';
import 'package:test/features/student/course_details/presentation/widgets/vertical_validator.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:test/features/teacher/course_details/presentation/widgets/course_info_teacher_profile.dart';
import 'package:test/features/teacher/course_details/presentation/widgets/custom_contanier_course_teacher_profile.dart';
import 'package:test/features/teacher/course_details/presentation/widgets/lecture_item_teacher_profile.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';


class CourseDetailsTeacherProfileBody extends StatefulWidget {
  const CourseDetailsTeacherProfileBody({required this.course, super.key});
  final CoursesModel course;

  @override
  State<CourseDetailsTeacherProfileBody> createState() =>
      _CourseDetailsTeacherProfileBodyState();
}

class _CourseDetailsTeacherProfileBodyState
    extends State<CourseDetailsTeacherProfileBody> {
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _checkEnrollment();
  }

  Future<void> _checkEnrollment() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('userId', isEqualTo: user.uid)
        .where('courseId', isEqualTo: widget.course.id)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        _isEnrolled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      label: widget.course.title,
                      backgroundColor: const Color(0xffDBEAFE),
                      textColor: const Color(0xff2563EB),
                    ),
                    CustomContanierCourseTeacherProfile(
                      label: widget.course.status ?? '',
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
                    fontSize: 20.sp,
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
                SizedBox(height: 12.h),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.course.imageUrl ?? '',
                      ),
                      backgroundColor: context.color.mainColor,
                    ),
                    SizedBox(width: 10.w),
                    TextApp(
                      text: widget.course.teacherName,
                      theme: context.textStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.regular,
                        color: context.color.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    TextApp(
                      text: '(2.7 k reviews)',
                      theme: context.textStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.regular,
                        color: context.color.textColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    TextApp(
                      text: r'$ ',
                      theme: context.textStyle.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: context.color.bluePinkLight,
                      ),
                    ),
                    TextApp(
                      text: widget.course.price.toString(),
                      theme: context.textStyle.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: context.color.bluePinkLight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CourseInfoTeacherProfile(
                      icon: Icons.people,
                      label: '2.4k',
                      sub: 'Students',
                    ),
                    VertiDivider(),
                    CourseInfoTeacherProfile(
                      icon: Icons.access_time,
                      label: '24h',
                      sub: 'Duration',
                    ),
                    VertiDivider(),
                    CourseInfoTeacherProfile(
                      icon: Icons.video_collection,
                      label: '32',
                      sub: 'Lectures',
                    ),
                  ],
                ),
                const Divider(),
                SizedBox(height: 16.h),
                TextApp(
                  text: context.translate(LangKeys.aboutThisCourse),
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
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
                    height: 1.5.h,
                  ),
                ),
                SizedBox(height: 16.h),
                const BulletItem(text: 'Comprehensive SAT Math preparation'),
                const BulletItem(
                  text: 'Step-by-step problem-solving techniques',
                ),
                const BulletItem(text: 'Practice tests and quizzes'),
                const BulletItem(text: 'Detailed solution explanations'),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: context.translate(LangKeys.courseContent),
                      theme: context.textStyle.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeightHelper.bold,
                        color: context.color.textColor,
                      ),
                    ),
                    TextApp(
                      text: '32 lectures • 24 hours',
                      theme: context.textStyle.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeightHelper.regular,
                        color: context.color.textColor,
                      ),
                    ),
                  ],
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
                const Divider(),
                TextApp(
                  text: context.translate(LangKeys.studentReviews),
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                  ),
                ),
                const StudentList(),
                SizedBox(height: 20.h),
                CustomLinearButton(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    if (_isEnrolled) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              VideoPlayerPage(course: widget.course),
                        ),
                      );
                    } else {
                      _pay(context, widget.course);
                    }
                  },

                  child: TextApp(
                    text: _isEnrolled ? 'Go to Course' : 'اشترك الآن',
                    theme: context.textStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pay(BuildContext context, CoursesModel course) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (kDebugMode) {
          print('User not logged in');
        }
        return;
      }

      final manager = PaymobManager();
      final paymentKey = await manager.createPayment(
        amount: (course.price ?? 0).toInt(),
        currency: 'EGP',
        userId: user.uid,
        userName: user.displayName ?? 'Unknown',
        userEmail: user.email ?? 'unknown@email.com',
        courseId: course.id ?? '0',
        courseName: course.title,
        courseDescription: course.subTitle ?? 'No description',
        courseImage: course.imageUrl ?? '',
      );

      final orderId = manager.lastOrderId;
      final paymentUrl =
          'https://accept.paymob.com/api/acceptance/iframes/940163?payment_token=$paymentKey';

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentWebViewScreen(
            paymentUrl: paymentUrl,
            successRedirect: 'https://yourapp.com/payment-success',
            course: course,
            orderId: orderId,
          ),
        ),
      );

      if (result == true) {
        setState(() {
          _isEnrolled = true;
        });

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VideoPlayerPage(course: course),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Pay error: $e');
      }
    }
  }
}
