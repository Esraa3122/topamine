import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class FollowButton extends StatefulWidget {
  const FollowButton({
    required this.teacherId,
    required this.teacherName,
    super.key, required this.userModel,
  });

  final String teacherId;
  final String teacherName;
  final UserModel userModel;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton>
    with SingleTickerProviderStateMixin {
  bool isFollowing = false;
  int followersCount = 0;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getFollowData();
  }

  Future<void> getFollowData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.teacherId)
        .collection('followers')
        .doc(currentUserId)
        .get();

    final followersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.teacherId)
        .collection('followers')
        .get();

    if (!mounted) return;
    setState(() {
      isFollowing = doc.exists;
      followersCount = followersSnapshot.docs.length;
    });
  }

  Future<void> toggleFollow() async {
    final user = FirebaseAuth.instance.currentUser;
    final studentId = user?.uid;
    final studentName = user?.displayName ?? '';
    final studentEmail = user?.email ?? '';

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.teacherId)
        .collection('followers')
        .doc(currentUserId);

    setState(() => isFollowing = !isFollowing);

    if (isFollowing) {
      await ref.set({
        'studentId': studentId,
        'studentName': studentName,
        'studentEmail': studentEmail,
        'followedAt': Timestamp.now(),
      });
      setState(() => followersCount++);
    } else {
      await ref.delete();
      setState(() => followersCount--);
    }
  }

  Widget buildAnimatedButton({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, childWidget) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextApp(
          text: '$followersCount متابع',
          theme: TextStyle(
            fontSize: 14,
            color: context.color.textColor,
            fontWeight: FontWeightHelper.regular,
            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildAnimatedButton(
                delay: 0,
                child: ElevatedButton(
                  onPressed: toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFollowing
                        ? const Color.fromARGB(255, 167, 167, 167)
                        : Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextApp(
                      text: isFollowing ? '✓ متابع' : 'متابعة',
                      theme: const TextStyle(
                        fontSize: 13,
                        fontFamily: FontFamilyHelper.cairoArabic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (isFollowing)
              Expanded(
                child: buildAnimatedButton(
                  delay: 200,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final studentId = FirebaseAuth.instance.currentUser!.uid;
                      final teacherId = widget.teacherId;

                      final chatId = studentId.compareTo(teacherId) < 0
                          ? '${studentId}_$teacherId'
                          : '${teacherId}_$studentId';

                      context.pushNamed(
                        AppRoutes.chat,
                        arguments: {
                          'chatId': chatId,
                          'otherUser': widget.userModel,
                        },
                      );
                    },

                    icon: const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.message_rounded, size: 16),
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(8),
                      child: TextApp(
                        text: 'راسلني',
                        theme: TextStyle(
                          fontSize: 13,
                          fontFamily: FontFamilyHelper.cairoArabic,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 70, 172, 255),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
