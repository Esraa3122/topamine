class CourseModel {
  CourseModel({
    required this.image,
    required this.title,
    required this.teacher,
    required this.enrolledDate,
    this.status,
    this.subject,
  });
  final String image;
  final String title;
  final String teacher;
  final String enrolledDate;
  final String? status;
  final String? subject;
}
