// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class CourseRating {
//   final String courseId;
//   final String courseName;
//   final double average;

//   CourseRating({
//     required this.courseId,
//     required this.courseName,
//     required this.average,
//   });
// }

// Stream<List<CourseRating>> getCoursesAverageRatings() {
//   final currentId = FirebaseAuth.instance.currentUser!.uid;

//   return FirebaseFirestore.instance
//       .collection('courses')
//       .where('teacherId', isEqualTo: currentId)
//       .snapshots()
//       .asyncMap((coursesSnapshot) async {
//     if (coursesSnapshot.docs.isEmpty) return [];

//     List<CourseRating> results = [];

//     for (final courseDoc in coursesSnapshot.docs) {
//       final courseName = courseDoc['title'] ?? 'Unnamed Course';
//       final ratingsSnapshot =
//           await courseDoc.reference.collection('ratings').get();

//       var total = 0.0;
//       var count = 0;

//       for (final ratingDoc in ratingsSnapshot.docs) {
//         final raw = ratingDoc['rating'];
//         final value = raw is num
//             ? raw.toDouble()
//             : double.tryParse(raw.toString()) ?? 0.0;
//         total += value;
//         count++;
//       }

//       final avg = count == 0 ? 0.0 : total / count;

//       results.add(CourseRating(
//         courseId: courseDoc.id,
//         courseName: courseName.toString(),
//         average: avg,
//       ));
//     }

//     return results;
//   });
// }

// class RatingsCharts extends StatelessWidget {
//   const RatingsCharts({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<CourseRating>>(
//       stream: getCoursesAverageRatings(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         final courses = snapshot.data!;
//         if (courses.isEmpty) {
//           return const Center(child: Text("No ratings yet"));
//         }

//         final barGroups = List.generate(courses.length, (index) {
//           return BarChartGroupData(
//             x: index,
//             barRods: [
//               BarChartRodData(
//                 toY: courses[index].average,
//                 color: Colors.blue,
//                 width: 18,
//                 borderRadius: BorderRadius.circular(6),
//               )
//             ],
//           );
//         });

//         final spots = List.generate(courses.length, (index) {
//           return FlSpot(index.toDouble(), courses[index].average);
//         });

//         return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               SizedBox(
//                 height: 300,
//                 width: 400,
//                 child: BarChart(
//                   BarChartData(
//                     alignment: BarChartAlignment.spaceAround,
//                     barGroups: barGroups,
//                     borderData: FlBorderData(show: false),
//                     gridData: FlGridData(show: true),
//                     titlesData: FlTitlesData(
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             final idx = value.toInt();
//                             if (idx < 0 || idx >= courses.length) {
//                               return const SizedBox();
//                             }
//                             return Text(
//                               courses[idx].courseName,
//                               style: const TextStyle(fontSize: 10),
//                             );
//                           },
//                         ),
//                       ),
//                       leftTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: true),
//                       ),
//                       rightTitles:
//                           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       topTitles:
//                           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 30),
//               SizedBox(
//                 height: 300,
//                 width: 400,
//                 child: LineChart(
//                   LineChartData(
//                     lineBarsData: [
//                       LineChartBarData(
//                         spots: spots,
//                         isCurved: true,
//                         barWidth: 3,
//                         color: Colors.green,
//                         dotData: FlDotData(show: true),
//                       ),
//                     ],
//                     titlesData: FlTitlesData(
//                       bottomTitles: AxisTitles(
//                         sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             final idx = value.toInt();
//                             if (idx < 0 || idx >= courses.length) {
//                               return const SizedBox();
//                             }
//                             return Text(
//                               courses[idx].courseName,
//                               style: const TextStyle(fontSize: 10),
//                             );
//                           },
//                         ),
//                       ),
//                       leftTitles: const AxisTitles(
//                         sideTitles: SideTitles(showTitles: true),
//                       ),
//                       rightTitles:
//                           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                       topTitles:
//                           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
