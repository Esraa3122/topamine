import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test/core/service/cloudinary/cloudinary_service.dart';
import 'package:test/features/teacher/add_courses/data/model/courses_model.dart';
import 'package:video_player/video_player.dart';

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

  Future<String?> getVideoDuration(String url) async {
  try {
    final controller = VideoPlayerController.network(url);
    await controller.initialize();
    final duration = controller.value.duration;
    controller.dispose();

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours > 0
        ? "$hours:$minutes:$seconds"
        : "$minutes:$seconds";
  } catch (e) {
    return null;
  }
}


Future<void> updateCourse({
    required CoursesModel course,
    File? imageFile,
    List<LectureModel>? newLectures,
  }) async {
    String? imageUrl = course.imageUrl;

    if (imageFile != null) {
      imageUrl = await CloudinaryService.uploadFile(imageFile, 'image');
      if (imageUrl == null) throw Exception('Image upload failed');
    }

    final updatedCourse = course.copyWith(
      imageUrl: imageUrl,
      lectures: newLectures ?? course.lectures, 
    );

    await courseRef.doc(course.id).update(updatedCourse.toJson());
  }
}
