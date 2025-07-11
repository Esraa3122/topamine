import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';

class StudentTestimonials extends StatelessWidget {
  const StudentTestimonials({super.key});

  @override
  Widget build(BuildContext context) {
    final testimonials = <Map<String, String>>[
      {
        'name': 'أحمد علي',
        'image': 'https://i.pravatar.cc/150?img=8',
        'comment': 'المنصة ممتازة جدًا، والدروس منظمة وسهلة الفهم.',
        'rating': '5',
      },
      {
        'name': 'سارة محمد',
        'image': 'https://i.pravatar.cc/150?img=12',
        'comment': 'استفدت كثيرًا من المدرس، كان يشرح ببساطة وتفاعل رائع!',
        'rating': '4',
      },
      {
        'name': 'محمد سمير',
        'image': 'https://i.pravatar.cc/150?img=6',
        'comment': 'خدمة الدعم الفني سريعة جدًا والدورات ممتازة.',
        'rating': '5',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextApp(
          text: context.translate(LangKeys.studentsOpinions),
          theme: context.textStyle.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeightHelper.bold,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 170.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final item = testimonials[index];
              return SizedBox(
                width: 300.w,
                child: Card(
                  color: context.color.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item['image']!),
                          radius: 20,
                        ),
                        title: TextApp(
                          text: item['name']!,
                          theme: context.textStyle.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeightHelper.bold,
                            color: context.color.textColor,
                          ),
                        ),
                        subtitle: TextApp(
                          text: 'الصف الثالث الثانوى',
                          maxLines: 1,
                          theme: context.textStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeightHelper.medium,
                            color: context.color.textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              starIndex < int.parse(item['rating']!)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextApp(
                          text: item['comment']!,
                          maxLines: 3,
                          theme: context.textStyle.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeightHelper.bold,
                            color: context.color.textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
