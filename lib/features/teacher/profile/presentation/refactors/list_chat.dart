import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/features/student/chat/presentation/screen/chat_screen.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'قائمة الطلاب',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: context.color.bluePinkLight,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                return const Center(
                  child: Text(
                    'لا توجد محادثات من طلاب حالياً',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: studentChats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final chat = studentChats[index];
                  final student = chat['student'];
                  final lastMessage = chat['lastMessage'] ?? 'ابدأ المحادثة';
                  final Timestamp? timestamp = chat['lastMessageTime'] as Timestamp?;
                  final time = timestamp != null ? _formatTimeAgo(timestamp.toDate()) : '';
                  final chatId = chat['chatId'];

                  return FutureBuilder<int>(
                    future: _getUnreadMessagesCount(chatId.toString(), currentUserId),
                    builder: (context, unreadSnapshot) {
                      final unreadCount = unreadSnapshot.data ?? 0;

                      return Card(
                        color: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundImage: student['avatar'] != null &&
                                    student['avatar'].toString().isNotEmpty
                                ? NetworkImage(student['avatar'].toString())
                                : null,
                            child: student['avatar'] == null ||
                                    student['avatar'].toString().isEmpty
                                ? const Icon(Icons.person, size: 28, color: Colors.white)
                                : null,
                            backgroundColor: Colors.blueAccent.shade100,
                          ),
                          title: Text(
                            student['name']?.toString() ?? 'طالب',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage.toString() + (time.isNotEmpty ? ' · $time' : ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          trailing: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.arrow_forward_ios,
                                  size: 18, color: context.color.bluePinkLight),
                              if (unreadCount > 0)
                                Positioned(
                                  right: -6,
                                  top: -6,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      unreadCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(chatId: chatId.toString()),
                              ),
                            );
                          },
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
      List<QueryDocumentSnapshot> chats, String teacherId) async {
    List<Map<String, dynamic>> studentChats = [];

    for (var chat in chats) {
      final chatId = chat.id;
      if (!chatId.contains(teacherId)) continue;

      final ids = chatId.split('_');
      if (ids.length != 2) continue;

      final studentId = ids[0] == teacherId ? ids[1] : ids[0];

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

      if (createdBy != studentId) continue;

      final studentDoc =
          await FirebaseFirestore.instance.collection('users').doc(studentId).get();

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

  Future<int> _getUnreadMessagesCount(String chatId, String teacherId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('createdBy', isNotEqualTo: teacherId)
        .where('isRead', isEqualTo: false)
        .get();

    return snapshot.docs.length;
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
