import 'package:flutter/material.dart';
import 'package:test/features/student/course_details/data/model/student_model.dart';
import 'package:test/features/student/course_details/presentation/widgets/student_card.dart';

class StudentList extends StatelessWidget {
  const StudentList({super.key});

  @override
  Widget build(BuildContext context) {
    final students = <StudentModel>[
      StudentModel(
        name: 'Sarah Johnson',
        subject:
            'Excellent course! The instructor explains complex concepts in a very clear way.',
        imageUrl: 'https://i.pravatar.cc/150?img=1',
        rating: 4.5,
      ),
      StudentModel(
        name: 'Michael Chen',
        subject:
            'Excellent course! The instructor explains complex concepts in a very clear way.',
        imageUrl: 'https://i.pravatar.cc/150?img=2',
        rating: 4,
      ),
      StudentModel(
        name: 'Emily Brown',
        subject:
            'Excellent course! The instructor explains complex concepts in a very clear way.',
        imageUrl: 'https://i.pravatar.cc/150?img=3',
        rating: 4.3,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return StudentCard(student: students[index]);
      },
    );
  }
}
