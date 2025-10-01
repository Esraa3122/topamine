import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/loading/empty_screen.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/language/lang_keys.dart';
import 'package:test/core/routes/app_routes.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/features/auth/data/models/user_model.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.translate(LangKeys.listStudents),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: FontFamilyHelper.cairoArabic,
            letterSpacing: 0.5,
            fontSize: 22,
            color: Colors.white,
          ),
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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
            gradient: LinearGradient(
              colors: [
                context.color.bluePinkLight!,
                context.color.bluePinkDark!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitSpinningLines(
                color: context.color.bluePinkLight!,
                size: 50.sp,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ أثناء جلب البيانات'));
          }

          final chatDocs = snapshot.data?.docs ?? [];

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _getChatsStartedByStudents(chatDocs, currentUserId),
            builder: (context, futureSnapshot) {
              if (!futureSnapshot.hasData) {
                return Center(
                  child: SpinKitSpinningLines(
                    color: context.color.bluePinkLight!,
                    size: 50.sp,
                  ),
                );
              }

              final studentChats = futureSnapshot.data!;

              if (studentChats.isEmpty) {
                return const EmptyScreen(
                  title: 'لا يوجد محادثات',
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: studentChats.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final chat = studentChats[index];
                  final student = chat['student'];
                  final otherUser = UserModel.fromJson(student as Map<String, dynamic>);
                  final lastMessage = chat['lastMessage'] ?? 'ابدأ المحادثة';
                  final Timestamp? timestamp =
                      chat['lastMessageTime'] as Timestamp?;
                  final time = timestamp != null
                      ? _formatTimeAgo(timestamp.toDate())
                      : '';
                  final chatId = chat['chatId'];

                  return FutureBuilder<int>(
                    future: _getUnreadMessagesCount(
                      chatId.toString(),
                      currentUserId,
                    ),
                    builder: (context, unreadSnapshot) {
                      final unreadCount = unreadSnapshot.data ?? 0;

                      return Card(
                        color: unreadCount > 0
                            ? Colors.blue.shade50
                            : context.color.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: unreadCount > 0 ? 3 : 2,
                        shadowColor: unreadCount > 0
                            ? Colors.blue.shade100
                            : Colors.blue.shade200,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 28,
                            backgroundImage:
                                student['avatar'] != null &&
                                    student['avatar'].toString().isNotEmpty
                                ? NetworkImage(student['avatar'].toString())
                                : null,
                            backgroundColor: Colors.blueAccent.shade100,
                            child:
                                student['avatar'] == null ||
                                    student['avatar'].toString().isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          title: Text(
                            student['name']?.toString() ?? 'طالب',
                            style: TextStyle(
                              color: unreadCount > 0
                                  ? Colors.black
                                  : context.color.textColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: FontFamilyHelper.cairoArabic,
                              letterSpacing: 0.5,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            lastMessage.toString() +
                                (time.isNotEmpty ? ' · $time' : ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontFamily: FontFamilyHelper.cairoArabic,
                              letterSpacing: 0.5,
                            ),
                          ),
                          trailing: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 22,
                                color: context.color.bluePinkLight,
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 2,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {
                            context.pushNamed(
                              AppRoutes.chat,
                              arguments: {
                                'chatId': chatId,
                                'otherUser': otherUser,
                              },
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
    List<QueryDocumentSnapshot> chats,
    String teacherId,
  ) async {
    final studentChats = <Map<String, dynamic>>[];

    for (final chat in chats) {
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

      final studentDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(studentId)
          .get();

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
        .where('isRead', isEqualTo: false)
        .get();

    final unreadMessages = snapshot.docs
        .where(
          (doc) => doc['createdBy'] != teacherId,
        )
        .toList();

    return unreadMessages.length;
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
