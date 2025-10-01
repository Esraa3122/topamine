import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/custom_linear_button.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';
import 'package:test/features/student/home/presentation/widgets/build_stars.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({required this.teacher, super.key, this.coursesModel});
  final UserModel teacher;
  final CoursesModel? coursesModel;

 Stream<RatingSummary> getRatingSummary(String teacherId) async* {
  final coursesStream = FirebaseFirestore.instance
      .collection('courses')
      .where('teacherId', isEqualTo: teacherId)
      .snapshots();

  await for (final coursesSnapshot in coursesStream) {
    if (coursesSnapshot.docs.isEmpty) {
      yield RatingSummary(0.0, 0);
      continue;
    }

    var totalRating = 0.0;
    var totalCount = 0;

    for (final courseDoc in coursesSnapshot.docs) {
      final ratingsSnapshot = await courseDoc.reference
          .collection('ratings')
          .get();

      for (final ratingDoc in ratingsSnapshot.docs) {
        final ratingRaw = ratingDoc['rating'];
        final ratingNum = ratingRaw is num
            ? ratingRaw.toDouble()
            : double.tryParse(ratingRaw.toString()) ?? 0.0;

        totalRating += ratingNum;
        totalCount++;
      }
    }

    final avg = totalCount == 0 ? 0.0 : totalRating / totalCount;
    yield RatingSummary(avg, totalCount);
  }
}


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      child: Card(
        color: context.color.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        shadowColor: context.color.bluePinkLight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(teacher.userImage ?? ''),
              ),
              title: TextApp(
                text: teacher.userName,
                maxLines: 1,
                theme: context.textStyle.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeightHelper.bold,
                  color: context.color.textColor,
                  letterSpacing: 0.5,
                  fontFamily: FontFamilyHelper.cairoArabic,
                ),
              ),
              subtitle: TextApp(
                text: teacher.subject ?? 'No Subject',
                maxLines: 1,
                theme: context.textStyle.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeightHelper.medium,
                  color: context.color.textColor,
                  letterSpacing: 0.5,
                  fontFamily: FontFamilyHelper.cairoArabic,
                ),
              ),
              trailing: CustomLinearButton(
                width: 50.w,
                height: 30.h,
                onPressed: () {
                  context.pushNamed(
                    AppRoutes.teacherProfile2,
                    arguments: teacher,
                  );
                },
                child: TextApp(
                  text: context.translate(LangKeys.view),
                  theme: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontFamily: FontFamilyHelper.cairoArabic,
                  ),
                ),
              ),
            ),
            StreamBuilder<RatingSummary>(
  stream: getRatingSummary(teacher.userId),
  builder: (context, snapshot) {
    final data = snapshot.data;
    final avg = data?.average ?? 0.0;
    final count = data?.count ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${avg.toStringAsFixed(1)} ',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.amber,
            fontWeight: FontWeightHelper.regular,
            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
          ),
        ),
        buildStars(avg),
        const SizedBox(width: 6),
        Text(
          '($count ${context.translate(LangKeys.reviews)})',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeightHelper.regular,
            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  },
),

            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}

class RatingSummary {
  final double average;
  final int count;

  RatingSummary(this.average, this.count);
}
