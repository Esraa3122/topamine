import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/features/teacher/home/presentation/refactors/home_teacher_body.dart';
import 'package:test/features/teacher/home/presentation/widgets/dashboard_charts.dart';
import 'package:test/features/teacher/home/presentation/widgets/welcome_banner.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeBanner(),
            // SizedBox(height: 20),
            // SubscriptionsChart(),
            // SizedBox(height: 20),
            HomeTeacherBody(),
            SizedBox(height: 20),
            DashboardCharts(),
            SizedBox(height: 20),
            // CoursesRatingsPieChart(),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [context.color.bluePinkLight!, context.color.bluePinkDark!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            context.pushNamed(AppRoutes.chatBoot);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SvgPicture.asset(
            AppImages.chatboot,
            color: Colors.white,
            height: 25.h,
          ),
        ),
      ),
    );
  }
}
