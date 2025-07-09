import 'package:flutter/material.dart';

class StudentTestimonials extends StatelessWidget {
  const StudentTestimonials({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> testimonials = [
      {
        "name": "أحمد علي",
        "image": "https://i.pravatar.cc/150?img=8",
        "comment": "المنصة ممتازة جدًا، والدروس منظمة وسهلة الفهم.",
        "rating": "5",
      },
      {
        "name": "سارة محمد",
        "image": "https://i.pravatar.cc/150?img=12",
        "comment": "استفدت كثيرًا من المدرس، كان يشرح ببساطة وتفاعل رائع!",
        "rating": "4",
      },
      {
        "name": "محمد سمير",
        "image": "https://i.pravatar.cc/150?img=6",
        "comment": "خدمة الدعم الفني سريعة جدًا والدورات ممتازة.",
        "rating": "5",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Students' opinions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = testimonials[index];
              return Container(
                width: 240,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(item['image']!),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item['name']!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (starIndex) => Icon(
                          starIndex < int.parse(item['rating']!)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        item['comment']!,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
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
  }
}
