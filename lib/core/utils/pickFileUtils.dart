import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class PickFileUtils {
  static Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  static Future<File?> pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    return video != null ? File(video.path) : null;
  }

  static Future<File?> pickDocument({List<String>? extensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions ?? ['pdf', 'doc', 'docx', 'txt'],
    );
    return result != null ? File(result.files.single.path!) : null;
  }
}
