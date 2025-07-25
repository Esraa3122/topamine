import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingTabWidget extends StatelessWidget {
  const RatingTabWidget({required this.lectureTitle, super.key});
  final String lectureTitle;

  @override
  Widget build(BuildContext context) {
    if (lectureTitle.isEmpty) {
      return const Center(
        child: Text(
          'Opinions cannot be loaded because the lecture title is missing.',
        ),
      );
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lectures')
          .doc(lectureTitle)
          .collection('ratings')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(child: Text('لا يوجد آراء بعد.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          separatorBuilder: (_, _) => const Divider(),
          itemBuilder: (context, index) {
            final data = docs[index].data()! as Map<String, dynamic>;
            final rating = data['rating'] ?? 0;
            final name = data['name'] ?? 'طالب مجهول';
            final comment = data['comment']?.toString() ?? '';
            final avatarUrl = data['avatar']?.toString() ?? '';

            return ListTile(
              leading: avatarUrl.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                    )
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
