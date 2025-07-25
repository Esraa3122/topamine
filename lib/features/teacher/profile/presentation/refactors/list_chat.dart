import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/features/student/chat/presentation/screen/chat_screen.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('قائمة الطلاب')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'student')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء جلب البيانات'));
          }

          final students = snapshot.data?.docs ?? [];

          if (students.isEmpty) {
            return const Center(child: Text('لا يوجد طلاب حالياً'));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final studentId = student.id;
              final studentName = student['name'] ?? 'طالب بدون اسم';

              final chatId = _generateChatId(currentUserId, studentId);

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('chats')
                    .where('chatId', isEqualTo: chatId)
                    .orderBy('createdAt', descending: true)
                    .limit(1)
                    .get(),
                builder: (context, chatSnapshot) {
                  String lastMessage = 'ابدأ المحادثة';
                  String timeAgo = '';

                  if (chatSnapshot.hasData &&
                      chatSnapshot.data!.docs.isNotEmpty) {
                    final lastDoc = chatSnapshot.data!.docs.first;
                    final message = lastDoc['message'] ?? '';
                    final timestamp = lastDoc['createdAt'] as Timestamp;
                    final date = timestamp.toDate();
                    lastMessage = message.toString();
                    timeAgo = ' · ${_formatTimeAgo(date)}';
                  }

                 return ListTile(
  leading: CircleAvatar(
    radius: 24,
    backgroundImage: student['avatar'] != null && student['avatar'].toString().isNotEmpty
        ? NetworkImage(student['avatar'].toString())
        : null,
    child: student['avatar'] == null || student['avatar'].toString().isEmpty
        ? const Icon(Icons.person, size: 28)
        : null,
  ),
  title: Text(studentName.toString()),
  subtitle: Text('$lastMessage$timeAgo'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(chatId: chatId),
      ),
    );
  },
);

                },
              );
            },
          );
        },
      ),
    );
  }

  String _generateChatId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'الآن';
    if (diff.inMinutes < 60) return 'قبل ${diff.inMinutes} دقيقة';
    if (diff.inHours < 24) return 'قبل ${diff.inHours} ساعة';
    if (diff.inDays == 1) return 'أمس';
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }
}
