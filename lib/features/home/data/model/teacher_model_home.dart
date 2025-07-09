class TeacherModel {

  TeacherModel({
    required this.name,
    required this.subject,
    required this.imageUrl,
    required this.rating,
    required this.reviews,
  });
  final String name;
  final String subject;
  final String imageUrl;
  final double rating;
  final int reviews;
}
