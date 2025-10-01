import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/service/paymob_manager/paymob_manager.dart';
import 'package:test/core/service/paymob_manager/webview.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/course_details/presentation/widgets/course_info.dart';
import 'package:test/features/student/course_details/presentation/widgets/custom_contanier_course.dart';
import 'package:test/features/student/course_details/presentation/widgets/lecture_item.dart';
import 'package:test/features/student/course_details/presentation/widgets/vertical_validator.dart';
import 'package:test/features/student/home/presentation/widgets/rating.dart';
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
  bool get _isOwner {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && widget.course.teacherId == user.uid;
  }

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
    return '$days ${context.translate(LangKeys.days)}';
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

  int parseDurationToMinutes(String? duration) {
  if (duration == null || duration.isEmpty) return 0;

  final parts = duration.split(':');
  if (parts.length != 2) return 0;

  final hours = int.tryParse(parts[0]) ?? 0;
  final minutes = int.tryParse(parts[1]) ?? 0;

  return hours * 60 + minutes;
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
    final totalDuration = widget.course.lectures!
    .map((e) => parseDurationToMinutes(e.duration))
    .fold<int>(0, (a, b) => a + b);
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Stack(
            children: [
              Image.network(
                widget.course.imageUrl ?? '',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
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
                TextApp(
                  text: widget.course.title,
                  theme: context.textStyle.copyWith(
                    fontSize: 25.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                TextApp(
                  text: widget.course.subTitle ?? '',
                  theme: context.textStyle.copyWith(
                    fontSize: 14.sp,
                    color: context.color.textColor!.withOpacity(0.6),
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                RatingWidget(courseId: widget.course.id.toString()),
                SizedBox(height: 8.h),
                TextApp(
                  text: '${widget.course.gradeLevel}',
                  theme: context.textStyle.copyWith(
                    color: context.color.textColor!.withOpacity(0.6),
                    fontSize: 13.sp,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12.h),
                TextApp(
                  text:
                      '${context.translate(LangKeys.addedBy)} ${widget.course.teacherName}',
                  theme: context.textStyle.copyWith(
                    fontSize: 13.sp,
                    color: context.color.bluePinkLight,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 16.sp,
                      color: context.color.textColor!.withOpacity(0.6),
                    ),
                    SizedBox(width: 4.w),
                    TextApp(
                      text:
                          '${context.translate(LangKeys.startDate)} ${DateFormat(
                                                  'yyyy/MM/dd',
                                                ).format(widget.course.startDate!)}',
                      theme: context.textStyle.copyWith(
                        color: context.color.textColor!.withOpacity(0.6),
                        fontSize: 13.sp,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.event,
                      size: 16.sp,
                      color: context.color.textColor!.withOpacity(0.6),
                    ),
                    SizedBox(width: 4.w),
                    TextApp(
                      text:
                          '${context.translate(LangKeys.endDate)} ${DateFormat(
                                                  'yyyy/MM/dd',
                                                ).format(widget.course.endDate!)}',
                      theme: context.textStyle.copyWith(
                        color: context.color.textColor!.withOpacity(0.6),
                        fontSize: 13.sp,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                TextApp(
                  text:
                      '${widget.course.price} ${context.translate(LangKeys.eGP)}',
                  theme: context.textStyle.copyWith(
                    color: context.color.textColor,
                    fontSize: 20.sp,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
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
                      sub: context.translate(LangKeys.duration),
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
                TextApp(
                  text: context.translate(LangKeys.courseContent),
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeightHelper.bold,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12.h),
                TextApp(
                  text:
                      '${widget.course.lectures!.length.toString()} ${context.translate(LangKeys.lecture)} . ${hours} ${context.translate(LangKeys.hours)} : ${minutes} ${context.translate(LangKeys.minutes)}',
                  theme: context.textStyle.copyWith(
                    color: context.color.textColor!.withOpacity(0.6),
                    fontSize: 13.sp,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 16.h),
                if (widget.course.lectures == null ||
                    widget.course.lectures!.isEmpty)
                  TextApp(
                    text: context.translate(LangKeys.noLecturesAvailable),
                    theme: context.textStyle.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey,
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
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
                        isLocked: !_isEnrolled && !_isOwner,
                      );
                    },
                  ),

                SizedBox(height: 24.h),
                TextApp(
                  text: 'التقييمات',
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeightHelper.bold,
                    fontFamily: FontFamilyHelper.cairoArabic,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 12.h),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.course.id)
                      .collection('ratings')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return TextApp(
                        text: 'لا توجد تقييمات بعد',
                        theme: context.textStyle.copyWith(
                          fontFamily: FontFamilyHelper.cairoArabic,
                          letterSpacing: 0.5,
                        ),
                      );
                    }

                    final reviews = snapshot.data!.docs;
                    final latestReviews = reviews.take(4).toList();


                    final avgRating =
                        reviews
                            .map((e) => (e['rating'] as num).toDouble())
                            .reduce((a, b) => a + b) /
                        reviews.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (i) {
                                if (i < avgRating.floor()) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                } else if (i == avgRating.floor() &&
                                    avgRating % 1 >= 0.5) {
                                  return const Icon(
                                    Icons.star_half,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                } else {
                                  return const Icon(
                                    Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                }
                              }),
                            ),
                            const SizedBox(width: 6),
                            TextApp(
                              text:
                                  '${avgRating.toStringAsFixed(1)} / 5  (${reviews.length} تقييم)',
                              theme: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.color.textColor,
                                fontFamily: FontFamilyHelper.cairoArabic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: latestReviews.length,
                          itemBuilder: (context, index) {
                            final review = latestReviews[index];
                            final rating =
                                (review['rating'] as num?)?.toDouble() ?? 0;
                            final comment = review['comment'] ?? '';
                            final userName = review['name'] ?? 'مستخدم';
                            final createdAt =
                                (review['createdAt'] as Timestamp?)?.toDate();
                            final userImage = review['avatar'];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: context.color.mainColor,
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage:
                                              userImage != null &&
                                                  userImage
                                                      .toString()
                                                      .isNotEmpty
                                              ? NetworkImage(
                                                  userImage.toString(),
                                                )
                                              : null,
                                          backgroundColor: Colors.grey.shade300,
                                          child:
                                              (userImage == null ||
                                                  userImage.toString().isEmpty)
                                              ? Text(
                                                  userName.toString().isNotEmpty
                                                      ? userName[0]
                                                            .toString()
                                                            .toUpperCase()
                                                      : "م",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextApp(
                                                text: userName.toString(),
                                                theme: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color:
                                                      context.color.textColor,
                                                  fontFamily: FontFamilyHelper
                                                      .cairoArabic,
                                                ),
                                              ),
                                              Row(
                                                children: List.generate(5, (i) {
                                                  if (i < rating.floor()) {
                                                    return const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    );
                                                  } else if (i ==
                                                          rating.floor() &&
                                                      rating % 1 >= 0.5) {
                                                    return const Icon(
                                                      Icons.star_half,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    );
                                                  } else {
                                                    return const Icon(
                                                      Icons.star_border,
                                                      color: Colors.amber,
                                                      size: 16,
                                                    );
                                                  }
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (createdAt != null)
                                          Text(
                                            DateFormat(
                                              'yyyy/MM/dd',
                                            ).format(createdAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: context.color.textColor!
                                                  .withOpacity(0.6),
                                              fontFamily:
                                                  FontFamilyHelper.cairoArabic,
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (comment.toString().isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      Text(
                                        comment.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: context.color.textColor,
                                          fontWeight: FontWeightHelper.regular,
                                          fontFamily:
                                              FontFamilyHelper.cairoArabic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20.h),

                CustomLinearButton(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    if (_isEnrolled || _isOwner) {
                      context.pushNamed(
                        AppRoutes.videoPlayerScreen,
                        arguments: widget.course,
                      );
                    } else {
                      _pay(context, widget.course);
                    }
                  },
                  child: TextApp(
                    text: _isEnrolled || _isOwner
                        ? context.translate(LangKeys.goToCourseNow)
                        : '${widget.course.price} ${context.translate(LangKeys.eGP)} - ${context.translate(LangKeys.subscribeNow)}',
                    theme: context.textStyle.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeightHelper.bold,
                      color: Colors.white,
                      fontFamily: FontFamilyHelper.cairoArabic,
                      letterSpacing: 0.5,
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
        // ignore: inference_failure_on_instance_creation
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
