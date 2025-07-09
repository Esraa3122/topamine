import 'package:flutter/material.dart';
import 'package:test/features/home/data/model/coures_model.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool showStatus;

  const CourseCard({super.key, required this.course, this.showStatus = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                course.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.teacher,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Enrolled: ${course.enrolledDate}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    if (showStatus) ...[
                      const SizedBox(height: 4),
                      Text(
                        course.status == "completed"
                            ? "Completed"
                            : "In Progress",
                        style: TextStyle(
                          color:
                              course.status == "completed"
                                  ? Colors.green
                                  : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
