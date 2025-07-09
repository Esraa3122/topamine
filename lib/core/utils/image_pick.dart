import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test/core/di/injection_container.dart';


class PickImageUtils {
  factory PickImageUtils() {
    return _instance;
  }
  const PickImageUtils._();

  static const PickImageUtils _instance = PickImageUtils._();

  Future<XFile?> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        // final bytes = await File(image.path).readAsBytes();
        // return base64Encode(bytes);
        return XFile(image.path);
      }
      return null;
    } catch (e) {
      final permissionStatus = await Permission.photos.status;

      if (permissionStatus.isDenied) {
        // show dialog
        await _showAlertPermissionsDialog();
      } else {
        debugPrint('Image Exception ==> $e');
      }
    }
    return null;
  }

  Future<void> _showAlertPermissionsDialog() {
    return showCupertinoDialog(
      context: sl<GlobalKey<NavigatorState>>().currentState!.context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Permissions Denied'),
          content: const Text('Allow access to gallery and photos'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: openAppSettings,
              child: Text('Settings'),
            ),
          ],
        );
      },
    );
  }
}
