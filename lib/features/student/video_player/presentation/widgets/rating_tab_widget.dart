import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';

class RatingTabWidget extends StatelessWidget {
  const RatingTabWidget({
    required this.courseId, super.key,
  });

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('ratings')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('لا توجد تقييمات بعد'));
        }

        final ratings = snapshot.data!.docs;

        final totalRatings = ratings.length;
        final avgRating = ratings.fold<double>(
              0,
              (sum, doc) =>
                  sum + ((doc['rating'] as num?)?.toDouble() ?? 0),
            ) /
            totalRatings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'متوسط التقييم',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return Icon(
                        i < avgRating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${avgRating.toStringAsFixed(1)} / 5 من $totalRatings تقييم",
                    style: TextStyle(fontSize: 14, color: context.color.textColor),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: ratings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final data =
                      ratings[index].data() as Map<String, dynamic>;

                  final name = data['name'] ?? "مستخدم";
                  final comment = data['comment'] ?? "";
                  final rating = (data['rating'] as num?)?.toInt() ?? 0;
                  final avatar = data['avatar'] ?? "";

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.color.mainColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          offset: const Offset(0, 3),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blueGrey.shade100,
                          backgroundImage: avatar.isNotEmpty as bool
                              ? NetworkImage(avatar.toString())
                              : null,
                          child: avatar.isEmpty as bool
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.toString(),
                                style: TextStyle(
                                  color: context.color.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 20,
                                  );
                                }),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                comment.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
