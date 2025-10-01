import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:test/core/extensions/context_extension.dart';

class DashboardCharts extends StatelessWidget {
  const DashboardCharts({super.key});

  Stream<Map<String, int>> getSubscriptionsPerMonth() async* {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    final coursesStream = FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .snapshots();

    await for (final coursesSnapshot in coursesStream) {
      final courseIds = coursesSnapshot.docs.map((d) => d.id).toList();

      if (courseIds.isEmpty) {
        yield {};
        continue;
      }

      final enrollmentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('courseId', whereIn: courseIds)
          .where('status', isEqualTo: 'success')
          .get();

      final counts = <String, int>{};

      for (final doc in enrollmentsSnapshot.docs) {
        final ts = doc['timestamp'] as Timestamp?;
        if (ts == null) continue;

        final date = ts.toDate();
        final month = '${date.month}/${date.year}';
        counts[month] = (counts[month] ?? 0) + 1;
      }

      yield counts;
    }
  }

  // 📈 Stream لمتوسط التقييمات لكل كورس
  Stream<Map<String, double>> getAverageRatings() {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .snapshots()
        .asyncMap((coursesSnapshot) async {
      if (coursesSnapshot.docs.isEmpty) return {};

      final averages = <String, double>{};

      for (final courseDoc in coursesSnapshot.docs) {
        final ratingsSnapshot =
            await courseDoc.reference.collection('ratings').get();

        var total = 0.0;
        var count = 0;

        for (final ratingDoc in ratingsSnapshot.docs) {
          final raw = ratingDoc['rating'];
          final value = raw is num
              ? raw.toDouble()
              : double.tryParse(raw.toString()) ?? 0.0;
          total += value;
          count++;
        }

        averages[courseDoc['title'].toString()] =
            count == 0 ? 0.0 : total / count;
      }

      return averages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 1,
      mainAxisSpacing: 20,
      childAspectRatio: 1.4,
      padding: const EdgeInsets.all(15),
      children: [
        // 🔹 Bar Chart للاشتراكات الشهرية
        StreamBuilder<Map<String, int>>(
          stream: getSubscriptionsPerMonth(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: SpinKitRing(color: Colors.blue));
            }

            final data = snapshot.data!;
            final months = data.keys.toList();
            final values = data.values.toList();

            if (months.isEmpty) {
              return const Center(child: Text('No subscriptions yet'));
            }

            return Container(
      decoration: BoxDecoration(
        color: context.color.mainColor,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: color.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Monthly Subscriptions',
                        style: TextStyle(
                            color: context.color.textColor,
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: List.generate(values.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: values[index].toDouble(),
                                  gradient: const LinearGradient(
                                    colors: [Colors.blue, Colors.indigo],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= months.length) {
                                    return const SizedBox();
                                  }
                                  return Text(months[index],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: context.color.textColor));
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 30)),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 700),
                        swapAnimationCurve: Curves.easeOutCubic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // 🔹 Bar Chart لمتوسط التقييمات
        StreamBuilder<Map<String, double>>(
          stream: getAverageRatings(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!;
            final courses = data.keys.toList();
            final averages = data.values.toList();

            if (courses.isEmpty) {
              return const Center(child: Text('No ratings yet'));
            }

            return Container(
      decoration: BoxDecoration(
        color: context.color.mainColor,
        borderRadius: BorderRadius.circular(16),
        // border: Border.all(color: color.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Average Ratings per Course',
                        style: TextStyle(
                          color: context.color.textColor,
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 5,
                          barGroups: List.generate(averages.length, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: averages[index],
                                  gradient: const LinearGradient(
                                    colors: [Colors.yellow, Colors.deepOrange],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= courses.length) {
                                    return const SizedBox();
                                  }
                                  return Text(
                                    courses[index],
                                    style: TextStyle(
                                        fontSize: 9,
                                        color: context.color.textColor),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 30)),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 700),
                        swapAnimationCurve: Curves.easeOutCubic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
