import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/features/student/home/data/model/teacher_model_home.dart';
import 'package:test/features/student/home/data/user_service.dart';
import 'package:test/features/student/home/presentation/widgets/teacher_card_home.dart';

class TeachersList extends StatefulWidget {
  const TeachersList({super.key});

  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  late Future<List<TeacherModel>> _teachersFuture;

  @override
  void initState() {
    super.initState();
    _teachersFuture = UserService().getTeachers();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: FutureBuilder<List<TeacherModel>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('error throw display teacher'));
          }
          final teachers = snapshot.data ?? [];
          if (teachers.isEmpty) {
            return const Center(child: Text('No Teacher Now'));
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: teachers.length,
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              return TeacherCard(teacher: teachers[index]);
            },
          );
        },
      ),
    );
  }
}
