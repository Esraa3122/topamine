import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> showRatingDialog(BuildContext context, String lectureTitle) async {
  final commentController = TextEditingController();
  int selectedRating = 3;
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
      .collection('lectures')
      .doc(lectureTitle)
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
          title: const Text(
            '⭐ أضف تقييمك',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    labelText: 'اكتب رأيك هنا',
                    labelStyle: TextStyle(color: Colors.grey[700]),
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
                Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      iconSize: 32,
                      icon: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          selectedRating = index + 1;
                        });
                      },
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
