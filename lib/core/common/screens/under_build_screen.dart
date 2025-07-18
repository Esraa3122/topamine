import 'package:flutter/material.dart';
import 'package:test/core/style/images/app_images.dart';

class PageUnderBuildScreen extends StatelessWidget {
  const PageUnderBuildScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.underBuild),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
