import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/core/service/cloudinary/cloudinary_service.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';

class AddCourseRepository {
  final courseRef = FirebaseFirestore.instance.collection('courses');

  Future<CoursesModel> addCourse({
    required CoursesModel course,
    required File imageFile,
  }) async {
    final imageUrl = await CloudinaryService.uploadFile(imageFile, 'image');
    if (imageUrl == null) throw Exception('Image upload failed');

    final courseWithImage = course.copyWith(
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );

    final docRef = await courseRef.add(courseWithImage.toJson());

    await docRef.update({'id': docRef.id});

    return courseWithImage.copyWith(id: docRef.id);
  }

  Future<String> uploadLectureFile(File file, String type) async {
    final url = await CloudinaryService.uploadFile(file, type);
    if (url == null) throw Exception('$type upload failed');
    return url;
  }

}

