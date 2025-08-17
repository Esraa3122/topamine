import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/home/presentation/widgets/auto_slider.dart';
import 'package:test/features/student/home/presentation/widgets/progress_badges.dart';
import 'package:test/features/teacher/home/presentation/widgets/course_for_you_home_teacher.dart';
import 'package:test/features/teacher/home/presentation/widgets/teacher_list_home_teacher.dart';

class HomeTeacherBody extends StatefulWidget {
  const HomeTeacherBody({super.key});

  @override
  State<HomeTeacherBody> createState() => _HomeTeacherBodyState();
}

class _HomeTeacherBodyState extends State<HomeTeacherBody> {
  final TextEditingController searchController = TextEditingController();
  // String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BannerSliders(),
        SizedBox(height: 20.h),
        // CategoryList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextApp(
              text: context.translate(LangKeys.coursesForYou),
              theme: context.textStyle.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(AppRoutes.allCoursesTeacherProfilePage);
              },
              child: TextApp(
                text: context.translate(LangKeys.viewAll),
                theme: context.textStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: context.color.bluePinkLight,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        const CourseForYouHomeTeacher(),
        SizedBox(height: 20.h),
        TextApp(
          text: context.translate(LangKeys.featuredTeachers),
          theme: context.textStyle.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        TextApp(
          text: context.translate(LangKeys.topRatedTutorsThisWeek),
          theme: context.textStyle.copyWith(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeightHelper.regular,
          ),
        ),
        SizedBox(height: 16.h),
        const TeacherListHomeTeacher(),
        SizedBox(height: 24.h),
        const StudentTestimonials(),
      ],
    );
  }
}
