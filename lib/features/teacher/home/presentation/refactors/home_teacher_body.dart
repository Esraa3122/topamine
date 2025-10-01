import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/features/teacher/home/presentation/widgets/build_stat_tile.dart';

class HomeTeacherBody extends StatelessWidget {
  const HomeTeacherBody({super.key});

    Stream<int> getActiveCoursesCount() {
    final currentId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<int> getInactiveCoursesCount() {
    final currentId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .where('status', isEqualTo: 'not active')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<double> getTotalPayments() async* {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    final coursesStream = FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .snapshots();

    await for (final coursesSnapshot in coursesStream) {
      final courseIds = coursesSnapshot.docs.map((d) => d.id).toList();

      if (courseIds.isEmpty) {
        yield 0.0;
        continue;
      }

      final paymentsSnapshot = await FirebaseFirestore.instance
          .collection('payments')
          .where('courseId', whereIn: courseIds)
          .where('status', isEqualTo: 'success')
          .get();

      var sum = 0.0;
      for (final doc in paymentsSnapshot.docs) {
        final amountRaw = doc['amount'];
        final amountNum = amountRaw is num
            ? amountRaw.toDouble()
            : double.tryParse(amountRaw.toString()) ?? 0.0;
        sum += amountNum;
      }

      yield sum;
    }
  }

  Stream<double> getAverageRating() async* {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    final coursesStream = FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .snapshots();

    await for (final coursesSnapshot in coursesStream) {
      if (coursesSnapshot.docs.isEmpty) {
        yield 0.0;
        continue;
      }

      var totalRating = 0.0;
      var totalCount = 0;

      for (final courseDoc in coursesSnapshot.docs) {
        final ratingsSnapshot = await courseDoc.reference
            .collection('ratings')
            .get();

        for (final ratingDoc in ratingsSnapshot.docs) {
          final ratingRaw = ratingDoc['rating'];
          final ratingNum = ratingRaw is num
              ? ratingRaw.toDouble()
              : double.tryParse(ratingRaw.toString()) ?? 0.0;

          totalRating += ratingNum;
          totalCount++;
        }
      }

      yield totalCount == 0 ? 0.0 : totalRating / totalCount;
    }
  }

  Stream<int> getStudentsCount() async* {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    final coursesStream = FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .snapshots();

    await for (final coursesSnapshot in coursesStream) {
      final courseIds = coursesSnapshot.docs.map((d) => d.id).toList();

      if (courseIds.isEmpty) {
        yield 0;
        continue;
      }

      final enrollmentsSnapshot = await FirebaseFirestore.instance
          .collection('enrollments')
          .where('courseId', whereIn: courseIds)
          .get();

      final count = enrollmentsSnapshot.docs.length;
      yield count;
    }
  }

  Stream<int> getTotalRatingsCount() async* {
    final currentId = FirebaseAuth.instance.currentUser!.uid;
    final coursesStream = FirebaseFirestore.instance
        .collection('courses')
        .where('teacherId', isEqualTo: currentId)
        .snapshots();

    await for (final coursesSnapshot in coursesStream) {
      var totalCount = 0;

      for (final courseDoc in coursesSnapshot.docs) {
        final ratingsSnapshot = await courseDoc.reference
            .collection('ratings')
            .get();
        totalCount += ratingsSnapshot.docs.length;
      }

      yield totalCount;
    }
  }

    Stream<int> getFollowersCount() {
    final currentId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentId)
        .collection('followers')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }



  @override
  Widget build(BuildContext context) {
        final cards = <Map<String, dynamic>>[
      {
        'title': context.translate(LangKeys.activeCourses),
        'icon': Icons.play_circle_fill,
        'stream': getActiveCoursesCount(),
        'formatter': (int? v) => '${v ?? 0}',
        'color': Colors.green,
        'type': 'int',
      },
      {
        'title': context.translate(LangKeys.inactiveCourses),
        'icon': Icons.pause_circle_filled,
        'stream': getInactiveCoursesCount(),
        'formatter': (int? v) => '${v ?? 0}',
        'color': Colors.grey,
        'type': 'int',
      },
      {
        'title': context.translate(LangKeys.totalPayments),
        'icon': Icons.attach_money,
        'stream': getTotalPayments(),
        'formatter': (double? v) => '${(v ?? 0).toStringAsFixed(2)} EGP',
        'color': Colors.teal,
        'type': 'double',
      },
      {
        'title': context.translate(LangKeys.followers),
        'icon': Icons.group,
        'stream': getFollowersCount(),
        'formatter': (int? v) => '${v ?? 0}',
        'color': Colors.blue,
        'type': 'int',
      },
      {
        'title': context.translate(LangKeys.subscriptions),
        'icon': Icons.subscriptions,
        'stream': getStudentsCount(),
        'formatter': (int? v) => '${v ?? 0}',
        'color': Colors.purple,
        'type': 'int',
      },
      {
        'title': context.translate(LangKeys.averageRating),
        'icon': Icons.star,
        'stream': getAverageRating(),
        'formatter': (double? v) => '${(v ?? 0).toStringAsFixed(1)} ⭐',
        'color': Colors.amber,
        'type': 'double',
      },
      {
        'title': context.translate(LangKeys.totalRatings),
        'icon': Icons.reviews,
        'stream': getTotalRatingsCount(),
        'formatter': (int? v) => '${v ?? 0}',
        'color': Colors.deepOrange,
        'type': 'int',
      },
    ];
    return GridView.builder(
  padding: const EdgeInsets.all(15),
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 18,
    mainAxisSpacing: 18,
    childAspectRatio: 1.1,
  ),
  itemCount: cards.length,
  itemBuilder: (context, index) {
  final c = cards[index];
  // final Color cardColor = c['color'] as Color; 

if (c['type'] == 'int') {
  return StreamBuilder<int>(
    stream: c['stream'] as Stream<int>,
    builder: (context, snapshot) {
      final value = snapshot.data;
      final text = (c['formatter'] as String Function(int?))(value);

      return StatCard(
        title: c['title'] as String,
        icon: c['icon'] as IconData,
        text: text,
        color: c['color'] as Color,
      );
    },
  );
} else {
  return StreamBuilder<double>(
    stream: c['stream'] as Stream<double>,
    builder: (context, snapshot) {
      final value = snapshot.data;
      final text = (c['formatter'] as String Function(double?))(value);

      return StatCard(
        title: c['title'] as String,
        icon: c['icon'] as IconData,
        text: text,
        color: c['color'] as Color,
      );
    },
  );
}

},

);

  }
}
