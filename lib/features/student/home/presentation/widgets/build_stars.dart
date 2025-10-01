import 'package:flutter/material.dart';

Widget buildStars(double rating) {
  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;
  int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  return Row(
    children: [
      for (int i = 0; i < fullStars; i++)
        const Icon(Icons.star, color: Colors.amber, size: 16),
      if (hasHalfStar)
        const Icon(Icons.star_half, color: Colors.amber, size: 16),
      for (int i = 0; i < emptyStars; i++)
        const Icon(Icons.star_border, color: Colors.amber, size: 16),
    ],
  );
}
