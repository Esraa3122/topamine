import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/student/home/data/model/teacher_model_home.dart';
import 'package:test/features/student/home/presentation/widgets/teacher_card_home.dart';
class TeachersList extends StatelessWidget {
  const TeachersList({super.key});

  @override
  Widget build(BuildContext context) {
    final teachers = <TeacherModel>[
      TeacherModel(
        name: 'Sarah Johnson',
        subject: 'Mathematics',
        imageUrl: 'https://i.pravatar.cc/150?img=1',
        rating: 4.5,
        reviews: 24,
      ),
      TeacherModel(
        name: 'Michael Chen',
        subject: 'English Literature',
        imageUrl: 'https://i.pravatar.cc/150?img=2',
        rating: 4,
        reviews: 32,
      ),
      TeacherModel(
        name: 'Emily Brown',
        subject: 'Science',
        imageUrl: 'https://i.pravatar.cc/150?img=3',
        rating: 4.3,
        reviews: 18,
      ),
      TeacherModel(
        name: 'David Wilson',
        subject: 'Languages',
        imageUrl: 'https://i.pravatar.cc/150?img=4',
        rating: 4.2,
        reviews: 27,
      ),
    ];

    return SizedBox(
      height: 130.h,
      child: Center(
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(width: 10.w,),
          scrollDirection: Axis.horizontal,
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            return TeacherCard(teacher: teachers[index]);
          },
        ),
      ),
    );
    
    // GridView.builder(
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   padding: const EdgeInsets.all(8),
    //   itemCount: teachers.length,
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2, 
    //     mainAxisSpacing: 12, 
    //     crossAxisSpacing: 12,
    //     childAspectRatio: 0.75,
    //   ),
    //   itemBuilder: (context, index) {
    //     return TeacherCard(teacher: teachers[index]);
    //   },
    // );
  }
}
