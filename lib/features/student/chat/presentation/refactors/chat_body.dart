import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test/core/common/widgets/text_app.dart';
import 'package:test/core/extensions/context_extension.dart';
import 'package:test/core/style/fonts/font_family_helper.dart';
import 'package:test/core/style/fonts/font_weight_helper.dart';
import 'package:test/features/student/chat/data/models/chats_model.dart';
import 'package:test/features/student/chat/presentation/widgets/chat_buble_for_student.dart';
import 'package:test/features/student/chat/presentation/widgets/chat_buble_for_teacher.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({required this.chatId, super.key});
  final String chatId;

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  late final CollectionReference messages;

  final TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  
  final String? currentUserEmail = FirebaseAuth.instance.currentUser!.email;
  final String? currentUserName =
      FirebaseAuth.instance.currentUser!.displayName ?? 'No Name';

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return 'Today';
    } else if (messageDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  @override
  void initState() {
    super.initState();
    messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages');
  }

Future<void> sendMessage(String messageText) async {
  final messageData = {
    'message': messageText,
    'createdAt': Timestamp.now(),
    'createdBy': currentUserId,
    'name': currentUserName,
    'emailUser': currentUserEmail,
    'isRead': false,
    'readAt': null,
  };

  final chatRef = FirebaseFirestore.instance
      .collection('chats')
      .doc(widget.chatId);

  await messages.add(messageData);

  final chatDoc = await chatRef.get();

  if (chatDoc.exists) {
    final docData = chatDoc.data() ?? {};
    final participants = List<String>.from(docData['participants'] as List? ?? []);

    if (!participants.contains(currentUserId)) {
      participants.add(currentUserId);
    }

    await chatRef.set({
      'participants': participants,
      'lastMessage': messageText, 
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));
  } else {
    await chatRef.set({
      'participants': [currentUserId],
      'lastMessage': messageText, 
      'lastMessageTime': Timestamp.now(),
    });
  }
}


  Future<void> markMessageAsRead(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;
    if (data['createdBy'] != currentUserId &&
        !(data['isRead'] as bool? ?? false)) {
      await doc.reference.update({
        'isRead': true,
        'readAt': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          final docs = asyncSnapshot.data!.docs;

          final messagesList = docs.map((doc) {
            final msg = Message.fromJson(doc.data()! as Map<String, dynamic>);
            markMessageAsRead(doc);
            return msg;
          }).toList();

          return Container(
            decoration: BoxDecoration(
              // color: context.color.chatboot,
              gradient: LinearGradient(
                colors: [
                  context.color.mainColor!,
                  Colors.blue.shade400,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final message = messagesList[index];
                      final messageDate = DateTime.fromMillisecondsSinceEpoch(
                        message.date,
                      );

                      var showHeader = false;
                      if (index == messagesList.length - 1) {
                        showHeader = true;
                      } else {
                        final nextMessage = messagesList[index + 1];
                        final nextMessageDate =
                            DateTime.fromMillisecondsSinceEpoch(
                              nextMessage.date,
                            );

                        if (messageDate.day != nextMessageDate.day ||
                            messageDate.month != nextMessageDate.month ||
                            messageDate.year != nextMessageDate.year) {
                          showHeader = true;
                        }
                      }

                      return Column(
                        children: [
                          if (showHeader)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: context.color.textColor!.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextApp(
                                  text: _formatDateHeader(messageDate),
                                  theme: context.textStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeightHelper.regular,
                                    fontFamily: FontFamilyHelper.cairoArabic,
                                    color: context.color.textColor,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          if (message.uId == currentUserId)
                            ChatBubbleStudent(message: message)
                          else
                            ChatBubbleTeacher(message: message),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: TextStyle(color: context.color.textColor),
                          cursorColor: context.color.bluePinkLight,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              color: context.color.textColor,
                            ),
                            filled: true,
                            fillColor: context.color.mainColor,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          final text = controller.text.trim();

                          if (text.isEmpty) return;

                          await sendMessage(text);
                          controller.clear();
                          await _controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                context.color.bluePinkLight!,
                                context.color.bluePinkDark!,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
