// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';


// class SubscriptionsChart extends StatelessWidget {
//   const SubscriptionsChart({super.key});

//   Stream<Map<String, int>> getSubscriptionsPerMonth() async* {
//     final currentId = FirebaseAuth.instance.currentUser!.uid;

//     final coursesStream = FirebaseFirestore.instance
//         .collection('courses')
//         .where('teacherId', isEqualTo: currentId)
//         .snapshots();

//     await for (final coursesSnapshot in coursesStream) {
//       final courseIds = coursesSnapshot.docs.map((d) => d.id).toList();

//       if (courseIds.isEmpty) {
//         yield {};
//         continue;
//       }

//       final enrollmentsSnapshot = await FirebaseFirestore.instance
//           .collection('enrollments')
//           .where('courseId', whereIn: courseIds)
//           .get();

//       final counts = <String, int>{};

//       for (var doc in enrollmentsSnapshot.docs) {
//         final ts = doc['timestamp'] as Timestamp?;
//         if (ts == null) continue;

//         final date = ts.toDate();
//         final month = '${date.month}/${date.year}';

//         counts[month] = (counts[month] ?? 0) + 1;
//       }

//       yield counts;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<Map<String, int>>(
//       stream: getSubscriptionsPerMonth(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const CircularProgressIndicator();

//         final data = snapshot.data!;
//         final months = data.keys.toList();
//         final values = data.values.toList();

//         if (months.isEmpty) {
//           return const Text("No subscriptions yet");
//         }

//         return SizedBox(
//   height: 300,
//   child: BarChart(
//     BarChartData(
//       alignment: BarChartAlignment.spaceAround,
//       barTouchData: BarTouchData(
//         enabled: true,
//         touchTooltipData: BarTouchTooltipData(
//           // tooltipBgColor: Colors.black87,
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             return BarTooltipItem(
//               '${months[group.x]} \n',
//               const TextStyle(
//                   color: Colors.white, fontWeight: FontWeight.bold),
//               children: [
//                 TextSpan(
//                   text: '${rod.toY.toInt()} students',
//                   style: const TextStyle(color: Colors.amber),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       gridData: FlGridData(
//         show: true,
//         getDrawingHorizontalLine: (value) => FlLine(
//           color: Colors.grey.withOpacity(0.2),
//           strokeWidth: 1,
//         ),
//       ),
//       borderData: FlBorderData(show: false),
//       titlesData: FlTitlesData(
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 32,
//             getTitlesWidget: (value, meta) {
//               final index = value.toInt();
//               if (index < 0 || index >= months.length) {
//                 return const SizedBox();
//               }
//               return Padding(
//                 padding: const EdgeInsets.only(top: 6),
//                 child: Text(
//                   months[index],
//                   style: const TextStyle(
//                     fontSize: 11,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 40,
//           ),
//         ),
//         topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//         rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
//       ),
//       barGroups: List.generate(values.length, (index) {
//         return BarChartGroupData(
//           x: index,
//           barRods: [
//             BarChartRodData(
//               toY: values[index].toDouble(),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//               width: 22,
//               borderRadius: BorderRadius.circular(6),
//               backDrawRodData: BackgroundBarChartRodData(
//                 show: true,
//                 toY: values.reduce((a, b) => a > b ? a : b).toDouble(),
//                 color: Colors.grey.withOpacity(0.1),
//               ),
//             ),
//           ],
//         );
//       }),
//     ),
//     swapAnimationDuration: const Duration(milliseconds: 800), 
//     swapAnimationCurve: Curves.easeOutCubic,
//   ),
// );
//       },
//     );
//   }
// }
