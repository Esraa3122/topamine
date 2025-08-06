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
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء جلب البيانات'));
          }

          final chatDocs = snapshot.data?.docs ?? [];

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getChatsStartedByStudents(chatDocs, currentUserId),
            builder: (context, futureSnapshot) {
              if (!futureSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final studentChats = futureSnapshot.data!;

              if (studentChats.isEmpty) {
                return const Center(child: Text('لا توجد محادثات من طلاب حالياً'));
              }

              return ListView.builder(
                itemCount: studentChats.length,
                itemBuilder: (context, index) {
                  final chat = studentChats[index];
                  final student = chat['student'];
                  final lastMessage = chat['lastMessage'] ?? 'ابدأ المحادثة';
                  final Timestamp? timestamp = chat['lastMessageTime'] as Timestamp?;
                  final time = timestamp != null
                      ? ' · ${_formatTimeAgo(timestamp.toDate())}'
                      : '';

                  final chatId = chat['chatId'];

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
                    title: Text(student['name'].toString() ?? 'طالب'),
                    subtitle: Text('$lastMessage$time'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(chatId: chatId.toString()),
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

  Future<List<Map<String, dynamic>>> _getChatsStartedByStudents(
    List<QueryDocumentSnapshot> chats,
    String teacherId,
  ) async {
    List<Map<String, dynamic>> studentChats = [];

    for (var chat in chats) {
      final chatId = chat.id;
      if (!chatId.contains(teacherId)) continue;

      // استخرج ID الطالب من chatId
      final ids = chatId.split('_');
      if (ids.length != 2) continue;

      final studentId = ids[0] == teacherId ? ids[1] : ids[0];

      // تحقق من أن أول رسالة من الطالب
      final messagesSnap = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt')
          .limit(1)
          .get();

      if (messagesSnap.docs.isEmpty) continue;

      final firstMessage = messagesSnap.docs.first;
      final createdBy = firstMessage['createdBy'];

      if (createdBy != studentId) continue; // الشات لم يبدأه الطالب

      // جلب بيانات الطالب
      final studentDoc = await FirebaseFirestore.instance.collection('users').doc(studentId).get();

      if (!studentDoc.exists) continue;

      studentChats.add({
        'chatId': chatId,
        'student': studentDoc.data(),
        'lastMessage': chat['lastMessage'],
        'lastMessageTime': chat['lastMessageTime'],
      });
    }

    return studentChats;
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
