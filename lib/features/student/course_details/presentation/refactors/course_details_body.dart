import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/course_details/presentation/widgets/bullet_item.dart';
import 'package:test/features/student/course_details/presentation/widgets/course_info.dart';
import 'package:test/features/student/course_details/presentation/widgets/custom_contanier_course.dart';
import 'package:test/features/student/course_details/presentation/widgets/lecture_item.dart';
import 'package:test/features/student/course_details/presentation/widgets/student_course.dart';
import 'package:test/features/student/course_details/presentation/widgets/vertical_validator.dart';
import 'package:test/features/student/home/data/model/coures_model.dart';

class CourseDetailsBody extends StatelessWidget {
  const CourseDetailsBody({required this.course, super.key});
  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(course.imageUrl),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomContanierCourse(
                      label: course.title,
                      backgroundColor: const Color(0xffDBEAFE),
                      textColor: const Color(0xff2563EB),
                    ),
                    CustomContanierCourse(
                      label: course.status,
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
                  text: course.title,
                  theme: context.textStyle.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeightHelper.bold,
                    color: context.color.textColor,
                  ),
                ),
                SizedBox(height: 8.h),
                TextApp(
                  text: course.subTitle,
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
                      backgroundImage: NetworkImage(course.imageUrl),
                      backgroundColor: context.color.mainColor,
                    ),
                    SizedBox(width: 10.w),
                    TextApp(
                      text: course.teacherName,
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
                      text: course.price.toString(),
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
                    CourseInfo(
                      icon: Icons.people,
                      label: '2.4k',
                      sub: 'Students',
                    ),
                    VertiDivider(),
                    CourseInfo(
                      icon: Icons.access_time,
                      label: '24h',
                      sub: 'Duration',
                    ),
                    VertiDivider(),
                    CourseInfo(
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
                  text:
                      'Master advanced mathematics concepts and prepare for SAT success with our comprehensive course. Perfect for high school students looking to excel in standardized tests.',
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
                if (course.lectures.isEmpty)
                  TextApp(
                    text: 'No lectures available',
                    theme: context.textStyle.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: course.lectures.map((lecture) {
                      return LectureItem(
                        lecture: lecture,
                        course: course,
                      );
                    }).toList(),
                  ),

                // const CourseSection(
                //   title: 'Algebra Fundamentals',
                //   subtitle: '8 lectures • 4h 15m',
                //   contents: [
                //     'Variables & Expressions',
                //     'Linear Equations',
                //     'Quadratic Equations',
                //     'Factoring',
                //     'Inequalities',
                //     'Systems of Equations',
                //     'Algebraic Word Problems',
                //     'Algebra Review Quiz',
                //   ],
                // ),
                // const CourseSection(
                //   title: 'Geometry and Trigonometry',
                //   subtitle: '12 lectures • 6h 45m',
                //   contents: [
                //     'Angles and Lines',
                //     'Triangles',
                //     'Circles',
                //     'Coordinate Geometry',
                //     'Trigonometric Ratios',
                //     'Trigonometric Identities',
                //     'Unit Circle',
                //     'Graphs of Trig Functions',
                //     'Solving Triangles',
                //     'Applications in Real Life',
                //     'Practice Problems',
                //     'Geometry Review',
                //   ],
                // ),
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
                SizedBox(
                  height: 20.h,
                ),
                CustomLinearButton(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  onPressed: () {
                    context.pushNamed(AppRoutes.paymentDetailsView);
                  },
                  child: TextApp(
                    text: context.translate(LangKeys.entrollNow),
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
}
