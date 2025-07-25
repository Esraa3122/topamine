import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/service/cloudinary/cloudinary_service.dart';
import 'package:test/core/style/images/app_images.dart';
import 'package:test/core/utils/image_pick.dart';

class UserAvatarImage extends StatefulWidget {
  const UserAvatarImage({required this.onImageUploaded, super.key});
  final void Function(File imageUrl) onImageUploaded;

  @override
  State<UserAvatarImage> createState() => _UserAvatarImageState();
}

class _UserAvatarImageState extends State<UserAvatarImage> {
  File? _imageFile;
  String? _imageUrl;
  // bool _isUploading = false;

  Future<void> _handlePickImage() async {
    final pickedImage = await PickImageUtils().pickImage();
    if (pickedImage != null) {
      setState(() => _imageFile = pickedImage);
      final uploadedUrl = await CloudinaryService.uploadImageToCloudinary(
        pickedImage,
      );
      if (uploadedUrl != null) {
        setState(() => _imageUrl = uploadedUrl);
        widget.onImageUploaded(pickedImage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomFadeInDown(
      duration: 500,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _imageFile != null
            ? FileImage(_imageFile!)
            : const AssetImage(AppImages.userAvatar) as ImageProvider,
        backgroundColor: Colors.black.withOpacity(0.2),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            IconButton(
              onPressed: _handlePickImage,
              icon: const Icon(Icons.add_a_photo),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
