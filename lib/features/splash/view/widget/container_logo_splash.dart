import 'package:flutter/material.dart';
import 'package:test/core/style/images/app_images.dart';

class ContainerLogoSplash extends StatelessWidget {
  const ContainerLogoSplash({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(AppImages.logo), 
                    fit: BoxFit.contain, 
                  ),
                ),
              );
  }
}