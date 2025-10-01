import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({required this.courseId, super.key});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('ratings')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Row(
            children: List.generate(
              5,
              (index) => const Icon(
                Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          );
        }

        final ratings = snapshot.data!.docs;
        if (ratings.isEmpty) {
          return Row(
            children: [
              Text(
                '0.0 ',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 12.sp,
                  fontWeight: FontWeightHelper.regular,
                  fontFamily: FontFamilyHelper.cairoArabic,
                  letterSpacing: 0.5,
                ),
              ),
              ...List.generate(
                5,
                (index) => const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(0)',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12.sp,
                  fontWeight: FontWeightHelper.regular,
                  fontFamily: FontFamilyHelper.cairoArabic,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          );
        }

        final totalRatings = ratings.length;
        final avgRating =
            ratings.fold<double>(
              0,
              (sum, doc) => sum + ((doc['rating'] as num?)?.toDouble() ?? 0),
            ) /
            totalRatings;

        int fullStars = avgRating.floor(); 
        bool hasHalfStar = (avgRating - fullStars) >= 0.5; 
        int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        return Row(
          children: [
            Text(
              '${avgRating.toStringAsFixed(1)} ',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 12.sp,
                fontWeight: FontWeightHelper.regular,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
              ),
            ),
            for (int i = 0; i < fullStars; i++)
              const Icon(Icons.star, color: Colors.amber, size: 16),

            if (hasHalfStar)
              const Icon(Icons.star_half, color: Colors.amber, size: 16),

            for (int i = 0; i < emptyStars; i++)
              const Icon(Icons.star_border, color: Colors.amber, size: 16),

            const SizedBox(width: 6),

            TextApp(
              text:  '($totalRatings)',
              theme: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
                fontWeight: FontWeightHelper.regular,
                fontFamily: FontFamilyHelper.cairoArabic,
                letterSpacing: 0.5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
