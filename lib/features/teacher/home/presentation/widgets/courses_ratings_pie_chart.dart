// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class CoursesRatingsPieChart extends StatelessWidget {
//   const CoursesRatingsPieChart({super.key});

//   /// Stream: بيرجع Map (courseName -> averageRating)
//   Stream<Map<String, double>> getCoursesAverageRatings() async* {
//     final currentId = FirebaseAuth.instance.currentUser!.uid;

//     final coursesStream = FirebaseFirestore.instance
//         .collection('courses')
//         .where('teacherId', isEqualTo: currentId)
//         .snapshots();

//     await for (final coursesSnapshot in coursesStream) {
//       if (coursesSnapshot.docs.isEmpty) {
//         yield {};
//         continue;
//       }

//       final averages = <String, double>{};

//       for (final courseDoc in coursesSnapshot.docs) {
//         final courseName = courseDoc['title'] ?? "Unnamed";
//         final ratingsSnapshot =
//             await courseDoc.reference.collection('ratings').get();

//         var totalRating = 0.0;
//         var totalCount = 0;

//         for (final ratingDoc in ratingsSnapshot.docs) {
//           final ratingRaw = ratingDoc['rating'];
//           final ratingNum = ratingRaw is num
//               ? ratingRaw.toDouble()
//               : double.tryParse(ratingRaw.toString()) ?? 0.0;

//           totalRating += ratingNum;
//           totalCount++;
//         }

//         averages[courseName.toString()] =
//             totalCount == 0 ? 0.0 : totalRating / totalCount;
//       }

//       yield averages;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, double>>(
//       stream: getCoursesAverageRatings(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final data = snapshot.data!;
//         if (data.isEmpty) {
//           return const Text("No ratings yet");
//         }

//         final courses = data.keys.toList();
//         final values = data.values.toList();

//         return Column(
//           children: [
//             SizedBox(
//               height: 300,
//               child: PieChart(
//                 PieChartData(
//                   sectionsSpace: 4,
//                   centerSpaceRadius: 60,
//                   startDegreeOffset: -90,
//                   sections: List.generate(courses.length, (index) {
//                     final color = Colors.primaries[index % Colors.primaries.length];
//                     return PieChartSectionData(
//                       value: values[index],
//                       title: values[index].toStringAsFixed(1),
//                       radius: 100,
//                       color: color,
//                       titleStyle: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 12,
//               runSpacing: 8,
//               children: List.generate(courses.length, (index) {
//                 return Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(
//                       width: 14,
//                       height: 14,
//                       decoration: BoxDecoration(
//                         color: Colors.primaries[index % Colors.primaries.length],
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     Text(
//                       courses[index],
//                       style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
