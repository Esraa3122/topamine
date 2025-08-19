import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test/core/extensions/context_extension.dart';

Future<void> showRatingDialog(BuildContext context, String courseId) async {
  final commentController = TextEditingController();
  var selectedRating = 3;
  final currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('يجب تسجيل الدخول لإرسال التقييم')),
    );
    return;
  }

  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .get();

  final userData = userDoc.data();
  if (userData == null) return;

  final ratingCollection = FirebaseFirestore.instance
      .collection('courses')
      .doc(courseId)
      .collection('ratings');

  final existingRating = await ratingCollection
      .where('userId', isEqualTo: currentUser.uid)
      .limit(1)
      .get();

  if (existingRating.docs.isNotEmpty) {
    final data = existingRating.docs.first.data();
    selectedRating = (data['rating'] as num?)?.toInt() ?? 3;
    commentController.text = data['comment']?.toString() ?? '';
  }

  await showDialog(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: context.color.mainColor,
          title: Text(
            '⭐ أضف تقييمك للكورس',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: context.color.textColor),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: commentController,
                  cursorColor: context.color.textColor,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: context.color.textColor,
                    ),
                  decoration: InputDecoration(
                    labelText: 'اكتب رأيك هنا',
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          index < selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'إرسال',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (commentController.text.trim().isEmpty) return;

                final ratingData = {
                  'comment': commentController.text.trim(),
                  'rating': selectedRating,
                  'createdAt': FieldValue.serverTimestamp(),
                  'userId': currentUser.uid,
                  'name': userData['name'],
                  'email': userData['email'],
                  'grade': userData['grade'],
                  'avatar': userData['avatar'] ?? '',
                };

                if (existingRating.docs.isNotEmpty) {
                  await ratingCollection
                      .doc(existingRating.docs.first.id)
                      .set(ratingData);
                } else {
                  await ratingCollection.add(ratingData);
                }

                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
