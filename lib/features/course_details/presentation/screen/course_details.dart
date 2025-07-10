import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/features/course_details/presentation/widgets/bullet_item.dart';
import 'package:test/features/course_details/presentation/widgets/course_info.dart';
import 'package:test/features/course_details/presentation/widgets/course_section.dart';
import 'package:test/features/course_details/presentation/widgets/custom_contanier_course.dart';
import 'package:test/features/course_details/presentation/widgets/student_course.dart';
import 'package:test/features/course_details/presentation/widgets/vertical_validator.dart';
import 'package:test/features/home/data/model/coures_model.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({this.course, super.key});
  final CourseModel? course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Course Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(course!.image),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomContanierCourse(
                        label: course?.subject ?? 'Subject',
                        backgroundColor: const Color(0xffDBEAFE),
                        textColor: const Color(0xff2563EB),
                      ),
                      CustomContanierCourse(
                        label: course?.status ?? 'Status',
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
                  Text(
                    course!.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'Comprehensive SAT Math Preparation',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      CircleAvatar(backgroundImage: AssetImage(course!.image)),
                      SizedBox(width: 10.w),
                      Text(course!.teacher),
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
                      Text(
                        '(2.7 k reviews)',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  const Text(
                    r'$199.99',
                    style: TextStyle(
                      color: Color(0xff2563EB),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
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
                  Text(
                    'About This Course',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  const Text(
                    'Master advanced mathematics concepts and prepare for SAT success with our comprehensive course. Perfect for high school students looking to excel in standardized tests.',
                    style: TextStyle(height: 1.5),
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
                      Text(
                        'Course Content',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('32 lectures • 24 hours'),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  const CourseSection(
                    title: 'Introduction to Advanced Mathematics',
                    subtitle: '5 lectures • 2h 30m',
                    contents: [
                      'Welcome & Overview',
                      'Key Concepts',
                      'Tools Needed',
                      'Getting Started',
                      'First Practice Set',
                    ],
                  ),
                  const CourseSection(
                    title: 'Algebra Fundamentals',
                    subtitle: '8 lectures • 4h 15m',
                    contents: [
                      'Variables & Expressions',
                      'Linear Equations',
                      'Quadratic Equations',
                      'Factoring',
                      'Inequalities',
                      'Systems of Equations',
                      'Algebraic Word Problems',
                      'Algebra Review Quiz',
                    ],
                  ),
                  const CourseSection(
                    title: 'Geometry and Trigonometry',
                    subtitle: '12 lectures • 6h 45m',
                    contents: [
                      'Angles and Lines',
                      'Triangles',
                      'Circles',
                      'Coordinate Geometry',
                      'Trigonometric Ratios',
                      'Trigonometric Identities',
                      'Unit Circle',
                      'Graphs of Trig Functions',
                      'Solving Triangles',
                      'Applications in Real Life',
                      'Practice Problems',
                      'Geometry Review',
                    ],
                  ),
                  const Divider(),
                  Text(
                    'Student Reviews',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                  const StudentList(),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomLinearButton(
                    height: 40.h,
                    width: MediaQuery.of(context).size.width,
                    onPressed: () {},
                    child: const Text('Entroll Now'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
