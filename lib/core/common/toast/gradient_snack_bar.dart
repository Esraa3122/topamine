import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';

class GradientSnackBar {
  static void show(BuildContext context, String message, Color color1, Color color2) {
    final controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: ScaffoldMessenger.of(context),
    )..repeat(reverse: true);

    final animation = Tween(begin: -1.0, end: 2.0).animate(controller);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        content: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color1,
                    color2,
                  ],
                  begin: Alignment(animation.value, 0),
                  end: Alignment(-animation.value, 0),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyle.copyWith(
                        color: Colors.white,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
