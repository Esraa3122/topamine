import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AnimationSplashScreen extends StatelessWidget {
  const AnimationSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpinKitThreeInOut(
      color: Colors.white,
      size: 20,
    );
  }
}
