import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingTabWidget extends StatelessWidget {
  const RatingTabWidget({required this.lectureTitle, super.key});
  final String lectureTitle;

  @override
  Widget build(BuildContext context) {
    if (lectureTitle.isEmpty || lectureTitle == 'There are no lectures.') {
      return const Center(
        child: Text(
          'Opinions cannot be uploaded due to lack of a valid lecture title.',
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lectures')
          .doc(lectureTitle.trim())
          .collection('ratings')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'An error occurred while loading the opinions: ${snapshot.error}',
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('There are no reviews yet.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>? ?? {};
            final rating = data['rating'] ?? 0;
            final name = data['name'] ?? 'طالب مجهول';
            final comment = data['comment']?.toString() ?? '';
            final avatarUrl = data['avatar']?.toString() ?? '';

            return ListTile(
              leading: avatarUrl.isNotEmpty
                  ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
                  : const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
              title: Row(
                children: [
                  Expanded(child: Text(name.toString())),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(' $rating'),
                ],
              ),
              subtitle: Text(comment),
            );
          },
        );
      },
    );
  }
}
