import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/common/animations/animate_do.dart';
import 'package:test/core/style/images/app_images.dart';

class UserAvararImage extends StatelessWidget {
  const UserAvararImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadeInDown(
      duration: 500,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: const AssetImage(AppImages.userAvatar),
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
              onPressed: (){},
  
              icon: const Icon(Icons.add_a_photo),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
