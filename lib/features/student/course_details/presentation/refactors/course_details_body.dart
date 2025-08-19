import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/paymob_manager/paymob_manager.dart';
import 'package:test/core/service/paymob_manager/webview.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/course_details/presentation/widgets/course_info.dart';
import 'package:test/features/student/course_details/presentation/widgets/custom_contanier_course.dart';
import 'package:test/features/student/course_details/presentation/widgets/lecture_item.dart';
import 'package:test/features/student/course_details/presentation/widgets/vertical_validator.dart';
import 'package:test/features/student/video_player/presentation/screen/video_payer_page.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class CourseDetailsBody extends StatefulWidget {
  const CourseDetailsBody({required this.course, super.key});
  final CoursesModel course;

  @override
  State<CourseDetailsBody> createState() => _CourseDetailsBodyState();
}

class _CourseDetailsBodyState extends State<CourseDetailsBody> {
  bool _isEnrolled = false;
  int enrolledCount = 0;

  @override
  void initState() {
    super.initState();
    _checkEnrollment();
    fetchEnrolledCount();
  }

  String formatDuration(Duration duration) {
    if (duration.isNegative) {
      return context.translate(LangKeys.end);
    }

    final days = duration.inDays;
    return '${days} ${context.translate(LangKeys.days)}';

    // final hours = duration.inHours % 24;
    // final minutes = duration.inMinutes % 60;

    // return '${days} يوم ${hours} ساعة ${minutes} دقيقة';
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
                    CustomContanierCourse(
                      label: widget.course.subject ?? '',
                      backgroundColor: const Color(0xffDBEAFE),
                      textColor: const Color(0xff2563EB),
                    ),
                    CustomContanierCourse(
                      label:
                          '${widget.course.lectures!.length} ${context.translate(LangKeys.lecture)}',
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
                SizedBox(height: 12.h),
                SizedBox(height: 16.h),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CourseInfo(
                      icon: Icons.people,
                      label: enrolledCount.toString(),
                      sub: context.translate(LangKeys.student),
                    ),
                    const VertiDivider(),
                    CourseInfo(
                      icon: Icons.access_time,
                      label: formatDuration(difference),
                      sub: context.translate(LangKeys.days),
                    ),
                    const VertiDivider(),
                    CourseInfo(
                      icon: Icons.video_collection,
                      label: widget.course.lectures!.length.toString(),
                      sub: context.translate(LangKeys.lecture),
                    ),
                  ],
                ),
                const Divider(),
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
                  ],
                ),
                SizedBox(height: 16.h),
                if (widget.course.lectures == null ||
                    widget.course.lectures!.isEmpty)
                  TextApp(
                    text: context.translate(LangKeys.noLecturesAvailable),
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
                      return LectureItem(
                        lecture: widget.course.lectures![index],
                        course: widget.course,
                        isLocked: !_isEnrolled,
                      );
                    },
                  ),
                SizedBox(height: 20.h),
                CustomLinearButton(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    if (_isEnrolled) {
                      context.pushNamed(
                        AppRoutes.videoPlayerScreen,
                        arguments: widget.course,
                      );
                    } else {
                      _pay(context, widget.course);
                    }
                  },

                  child: TextApp(
                    text: _isEnrolled
                        ? context.translate(LangKeys.goToCourseNow)
                        : '${widget.course.price} EGP - ${context.translate(LangKeys.subscribeNow)}',
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

      final result = await Navigator.pushReplacement(
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

         await context.pushNamed(
          AppRoutes.videoPlayerScreen,
          arguments: course,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Pay error: $e');
      }
    }
  }
}
